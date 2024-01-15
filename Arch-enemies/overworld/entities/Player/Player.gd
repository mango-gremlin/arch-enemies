extends CharacterBody2D

# --- / 
# -- / defining usage of signals 
signal saved_player()

# --- / 
# -- / default values for visualization

@export var SPEED = 100
@onready var anim:AnimatedSprite2D = $AnimatedSprite2D

# for correct animation: save last direction walked in, and if sprite was flipped
@onready var current_direction = "side"
@onready var h_flipped = false

# --- / 
# -- / player states
# collects all interactions that we currently have 
# Queue-like structure 
@onready var all_interactions = []

# TODO might be removed, for debugging only
@onready var interactionLabel = $interactioncomponents/InteractLabel

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
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= SPEED
		anim.play("back_walk")
		current_direction = "back"
	elif Input.is_action_pressed("move_down"):
		velocity.y += SPEED
		anim.play("front_walk")
		current_direction = "front"
	elif Input.is_action_pressed("move_left"):
		velocity.x -= SPEED
		h_flipped = true
		anim.play("side_walk")
		anim.flip_h = h_flipped
		current_direction = "side"
	elif Input.is_action_pressed("move_right"):
		velocity.x += SPEED
		h_flipped = false
		anim.play("side_walk")
		anim.flip_h = h_flipped
		current_direction = "side"
		
	elif velocity == Vector2.ZERO:
		player_idle_animation(delta)
		#anim.flip_h = false
		#anim.play("front_idle")
	
	move_and_collide(velocity * delta)

func player_idle_animation(delta):
	match current_direction:
		"side":
			anim.flip_h = h_flipped
			anim.play("front_idle")
		"front":
			anim.play("front_walk")
		"back":
			anim.play("back_walk")
		_:
			anim.play("front_idle")

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
	if not all_interactions.is_empty(): # interaction not empty
		
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
				print("entering bridge game")
				# FIXME debugging until interaction works accordingly
				print("value from interaction") 
				print(interaction_data["text"])
				print(interaction_data["issolved"])
				if interaction_data["issolved"]: 
					set_interactionLabel("Was solved already") 
					return
				else: 
					set_interactionLabel(interaction_data["text"])
					
				var bridge_edge:SingletonPlayer.BridgeEdge = interaction_data["bridge_edge"]
				save_player()
				enter_bridge_scene(bridge_edge)
				
			Interactable.InteractionType.ITEM: 
				print("obtained item")
				set_interactionLabel(interaction_data["text"])
				var received_item:Item.ItemType = interaction_data["item"]
				# adding to inventory 
				SingletonPlayer.add_to_inventory(received_item)
				# updating ui 
				# adding to inventory! 
			Interactable.InteractionType.NPC:
				print("interacting with npc")
				# entering dialogue, disable movement
				if not SingletonPlayer.check_dialogue_finished(interaction_data["npc_id"]):
					SingletonPlayer.enter_dialogue(interaction_data["npc_id"])
				else:
					set_interactionLabel(interaction_data["dialogue"])
				
				if not SingletonPlayer.has_dialogue(interaction_data["npc_id"]):
					set_interactionLabel("NO DIALOGUE")
				
				var reward_type:NPC_interaction.QuestReward = interaction_data["reward_type"]
				var received_reward = interaction_data["reward"]
				match reward_type:
					NPC_interaction.QuestReward.ANIMAL: 
						# adding animal to inventory of player 
						SingletonPlayer.add_to_animal_inventory(received_reward)
					NPC_interaction.QuestReward.ITEM: 
						SingletonPlayer.add_to_inventory(received_reward)

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
	# TODO 
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
			get_tree().change_scene_to_file(path_to_scene)

# ---- 
#  saving player state
# ---- 

func save_player():
	print("save user position")
	SingletonPlayer.set_player_coord(position)
	SingletonPlayer.save_game()
	saved_player.emit()
	

# ----- 
# debugging
# ----- 

func set_interactionLabel(label:String):
	interactionLabel.text = label
	

