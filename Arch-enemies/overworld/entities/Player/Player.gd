extends CharacterBody2D

# --- / 
# -- / defining usage of signals 
signal saved_player()

# --- / 
# -- / default values for visualization

@export var SPEED = 100
@onready var zoomlevel:Vector2 = SingletonPlayer.get_player_zoom()
@onready var anim:AnimatedSprite2D = $AnimatedSprite2D

# --- / 
# -- / player states
# collects all interactions that we currently have 
# Queue-like structure 
@onready var all_interactions = []

# TODO might be removed, for debugging only
@onready var interactionLabel = $interactioncomponents/InteractLabel

func _ready():
	#debug 
	$Camera2D.player_object = self
	#update_interactionLabel()

func _physics_process(delta):
	player_movement(delta)
	# checking for interaction in world
	check_input()

func player_movement(delta):
	# disallow movement when in dialogue
	if SingletonPlayer.is_in_dialogue:
		return
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= SPEED
		anim.play("back_walk")
	elif Input.is_action_pressed("move_down"):
		velocity.y += SPEED
		anim.play("front_walk")
	elif Input.is_action_pressed("move_left"):
		velocity.x -= SPEED
		anim.play("side_walk")
		anim.flip_h = true
	elif Input.is_action_pressed("move_right"):
		velocity.x += SPEED
		anim.play("side_walk")
		anim.flip_h = false
		
	elif velocity == Vector2.ZERO:
		anim.flip_h = false
		anim.play("front_idle")
	
	move_and_collide(velocity * delta)

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
				else: 
					set_interactionLabel(interaction_data["text"])
					
				var bridge_edge:SingletonPlayer.BridgeEdge = interaction_data["bridge_edge"]
				# FIXME map BridgeEdge data to given level accordingly
				#enter_bridge_scene(bridge_id)
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
				SingletonPlayer.enter_dialogue(interaction_data["npc_id"])
				SingletonPlayer.add_npc_talked_to(interaction_data["npc_id"])
				# debug --> visualize visited npcs
				print(SingletonPlayer.npc_talked_to)
				
				set_interactionLabel(interaction_data["dialogue"])
				# FIXME should be easier when done with separate **dialogue system**
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
	exit_overworld()
	# TODO 
	get_tree().change_scene_to_file("res://overworld/ui/menu/menu/pause_menu.tscn")

# TODO Outdated --> we dont have bridge_ids anymore 
func enter_bridge_scene(bridgeEdge:SingletonPlayer.BridgeEdge):
	var bridge_start:int = bridgeEdge.start_id
	var bridge_dest:int = bridgeEdge.dest_id
	
	print("entering bridge game from ", bridge_start, " to ", bridge_dest )
	exit_overworld()
	# TODO search for bridgeGame with correct id! 
	# load it afterwards
	# enter_pause_menu() # default until we merged
	get_tree().change_scene_to_file("res://bridges/scenes/bridge_1.tscn")
	

# prepare player to leave overworld, store its state 
func exit_overworld():
	# FIXME with SINGLETON conversion
	# -> only requires saving position of player for the given time 
	print("save user position")
	save_player()
	
# ---- 
#  saving player state
# ---- 

func save_player():
	print("save user position")
	SingletonPlayer.set_player_coord(position)
	saved_player.emit()
	
# TODO --> Singleton conversion!
func save_state():
	var json_inventory = []
	var item_inventory = SingletonPlayer.item_inventory
	for item:Item.ItemType in item_inventory:
		var item_amount = item_inventory[item]
		var item_string:String = Item.item_type_to_string(item)
		var item_dictionary:Dictionary = {
			"type": item_string,
			"amount": item_amount
		}
		# store amount
		item_dictionary["amount"] = item_amount
		json_inventory.append(item_dictionary)

	var state = {
		"name" : name,
		"parent" : get_parent().get_path(),
		# FIXME --> Singleton Conversion
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"inventory": json_inventory,
		"zoom": $Camera2D.current_zoom
	}
	return state
	
# ----- 
# debugging
# ----- 

func set_interactionLabel(label:String):
	interactionLabel.text = label
	

