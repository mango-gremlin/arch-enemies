extends CharacterBody2D

# --- / 
# -- / defining usage of signals 

# --- / 
# -- / default values for visualization

@export var SPEED = 100
@onready var anim:AnimatedSprite2D = $AnimatedSprite2D
@onready var player_hitbox = $CollisionShape2D
@onready var indicator_how_to_walk = $IndicatorWASDWalking

# for correct animation: save last direction walked in, and if sprite was flipped
# enum for animation types
enum DIRECTION {SIDE, FRONT, BACK}

@onready var current_direction = DIRECTION.SIDE
@onready var h_flipped = false

# --- / 
# -- / player states
# collects all interactions that we currently have 
# Queue-like structure 
@onready var all_interactions = []

# TODO might be removed, for debugging only
@onready var interactionLabel = $interactioncomponents/InteractLabel

# signal for audio
signal play_sound(sound)

# saving when closed via Request of OS
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("quitting game suddenly")
		save_player()
		SingletonPlayer.save_game()
		get_tree().quit() # default behavior

func _ready():
	# setting camera zoom
	var camera_reference = $Camera2D
	camera_reference.player_object = self
	camera_reference._set_current_zoom(SingletonPlayer.zoomlevel)
	position = SingletonPlayer.player_coordinate

func _physics_process(delta):
	player_movement(delta)
	# checking for interaction in world
	
	if SingletonPlayer.navigation_in_dialogue():
		return
	
	check_input()

func player_movement(delta):
	# disallow movement when in dialogue
	if SingletonPlayer.navigation_in_dialogue():
		return
		
	velocity = Vector2.ZERO
	
	Global.walking = true
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= SPEED
		anim.play("back_walk")
		current_direction = DIRECTION.BACK
	elif Input.is_action_pressed("move_down"):
		velocity.y += SPEED
		anim.play("front_walk")
		current_direction = DIRECTION.FRONT
	elif Input.is_action_pressed("move_left"):
		velocity.x -= SPEED
		h_flipped = true
		anim.play("side_walk")
		anim.flip_h = h_flipped
		current_direction = DIRECTION.SIDE
	elif Input.is_action_pressed("move_right"):
		velocity.x += SPEED
		h_flipped = false
		anim.play("side_walk")
		anim.flip_h = h_flipped
		current_direction = DIRECTION.SIDE
		
	elif velocity == Vector2.ZERO:
		player_idle_animation(delta)
		Global.walking = false
	
	player_rotate_hitbox(delta)
	
	# to prevent the following function from being called every delta
	if Global.walking and indicator_how_to_walk.visible:
		toggle_indicator_visibility(delta)
	
	move_and_collide(velocity * delta)

func player_idle_animation(delta):
	match current_direction:
		DIRECTION.SIDE:
			anim.flip_h = h_flipped
			anim.play("side_idle")
		DIRECTION.FRONT:
			anim.play("front_idle")
		DIRECTION.BACK:
			anim.play("back_idle")
		_:
			anim.play("side_idle")

func player_rotate_hitbox(delta):
	match current_direction:
		DIRECTION.SIDE:
			player_hitbox.set_rotation_degrees(0)
		DIRECTION.FRONT:
			player_hitbox.set_rotation_degrees(90)
		DIRECTION.BACK:
			player_hitbox.set_rotation_degrees(90)

func toggle_indicator_visibility(delta):
	# indicator displayed until first movement, then its set to invisible
	indicator_how_to_walk.visible = false
	

# ----- 
# --- structure interaction areas
# -----

func _on_interactionarea_area_entered(area):
	# we enter a new interaction into our list 
	all_interactions.insert(0,area)

func _on_interactionarea_area_exited(area):
	all_interactions.erase(area)

# function denoting how to interact with a given interaction in stack
# FIXME refactor!
func execute_interaction():
	if all_interactions.is_empty(): # interaction empty
		return 
	
	# taking first element from interaction
	var active_interaction = all_interactions[0]
	
	# query result from obtained interation 
	var obtained_interaction: Interactable.InteractionValue = active_interaction.interact_with_area()
	var interaction_data:Dictionary = obtained_interaction.valueDictionary
	match obtained_interaction.type:
		Interactable.InteractionType.BRIDGE: 
			# upon interaction with a bridge: 
			# check the following: 
			# solved already? 
			#	true  -> dont do anything 
			# 	false -> display information and allow to play game too 
			# FIXME debugging until interaction works accordingly
			var bridge_edge:SingletonPlayer.BridgeEdge = interaction_data["bridge_edge"]
			save_player()
			enter_bridge_scene(bridge_edge)
			
		Interactable.InteractionType.ITEM: 
			var received_item:Item.ItemType = interaction_data["item"]
			# adding to inventory 
			SingletonPlayer.add_to_inventory(received_item)
		Interactable.InteractionType.NPC:
			var npc_id:int = interaction_data["npc_id"]
			print("interacting with npc")
			# entering dialogue, disable movement
			var quest_done:bool = SingletonPlayer.obtain_npc_quest_state(npc_id)
			var dialogue_done:bool = SingletonPlayer.check_dialogue_finished(npc_id)
			
			# SOUND STUFF
			# play interaction sound here, depending on animal
			play_sound.emit("SQUIRREL") # not animal specific yet
			
			# allow dialogue as long as 
			# -> quest is undone
			# -> dialogue has not been finished yet! 
			#if not (dialogue_done and  quest_done):
			SingletonPlayer.prepare_dialogue(npc_id)
		
			# dialogue was finished already
			#SingletonPlayer.remove_quest_string(npc_id)
			#set_interactionLabel(interaction_data["dialogue"])
			
			if not SingletonPlayer.has_dialogue(npc_id):
				set_interactionLabel("NO DIALOGUE")
			
			# --- / 
			# -- / Reward management 
			# only necessary if NPC holds a quest
			var reward_type:NPC_interaction.QuestReward = interaction_data["reward_type"]
			var received_reward = interaction_data["reward"]
			# FIXME this can be a dictionary for QUESTREWARD == ANIMAL or ITEM
			print("taking reward from animal")
			match reward_type:
				NPC_interaction.QuestReward.ANIMAL: 
					# adding animal to inventory of player 
					# extracting information from Dictionary received
					print("adding animal to inventory ")
					var extracted_type:Animal.AnimalType = received_reward["type"]
					var received_amount:int = received_reward["amount"]
					print("amount" + str(received_amount) + "type " + Animal.type_to_string(extracted_type))
					SingletonPlayer.add_to_animal_inventory(extracted_type,received_amount)
				NPC_interaction.QuestReward.ITEM: 
					print("adding item to inventory ")
					var extracted_type:Item.ItemType = received_reward["type"]
					var received_amount:int = received_reward["amount"]
					SingletonPlayer.add_to_inventory(extracted_type,received_amount)
					#SingletonPlayer.add_to_inventory(received_reward)
				NPC_interaction.QuestReward.BRIDGE:
					# received a bridge, adding it to connected bridges
					var received_bridge:SingletonPlayer.BridgeEdge = received_reward["bridge_object"]
					var invalid_bridge_state = SingletonPlayer.BridgeLevelPathState.NONE
					if not (received_bridge.get_path_state() == invalid_bridge_state):
						SingletonPlayer.add_bridge_connection(received_bridge)

		Interactable.InteractionType.DEBUG:
			print("debug")
		_: 
			return 


# checks against definde inputs, takes action if action was registered
# TODO naming could be improved
func check_input():
	if Input.is_action_just_pressed("interact_overworld"):
		execute_interaction()
	if Input.is_action_just_pressed("use_item"):
		# FIXME debugging dialogue  --> resetting is_in_dialogue
		# TODO handled in Dialogue-System instead
		SingletonPlayer.exit_dialogue()
		set_interactionLabel("")
		pass
	if Input.is_action_just_pressed("open_menu"):
		enter_pause_menu()

# ---- 
# scene change management
# ---- 

func enter_pause_menu():
	print("pause menu")
	save_player()
	# FIXME improve menu 
	get_tree().change_scene_to_file("res://overworld/ui/menu/menu/pause_menu.tscn")

# takes received bridgeEdge and enters its path
# loads message to inform if no level was found
func enter_bridge_scene(bridgeEdge:SingletonPlayer.BridgeEdge):
	var updated_bridge_edge:SingletonPlayer.BridgeEdge = SingletonPlayer.obtain_bridge_scene(bridgeEdge)
	# either the bridgeEdge.path is set -> found scene 
	# or not 
	match updated_bridge_edge.path_state:
		SingletonPlayer.BridgeLevelPathState.NONE:
			# should not happen in normal operation
			set_interactionLabel("no scene available :(")
		SingletonPlayer.BridgeLevelPathState.AVAILABLE:
			# found matching path 
			var path_to_scene:String = updated_bridge_edge.path
			#exit_overworld()
			SingletonPlayer.set_current_bridge_edge(bridgeEdge)
			get_tree().change_scene_to_file(path_to_scene)

# ---- 
#  saving player state
# ---- 

func save_player():
	print("save user position")
	SingletonPlayer.set_player_coord(position)

# ----- 
# debugging
# ----- 

func set_interactionLabel(label:String):
	interactionLabel.text = label
	

