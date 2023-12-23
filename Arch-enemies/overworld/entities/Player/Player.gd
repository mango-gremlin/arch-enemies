extends CharacterBody2D

signal updated_inventory(new_inventory)
signal saved_player()

# --- / 
# -- / default values for visualization

@export var SPEED = 100
@export var zoomlevel:Vector2 = Vector2(1,1)
@onready var anim:AnimatedSprite2D = $AnimatedSprite2D

# --- / 
# -- / player states

# Array to hold the players useable items 
@onready var inventory:Dictionary = Item.init_items()

# Array to hold hte players progess in the world 
# used to check whether the user can traverse a certain region
# here each item is of type INT denoting the LEVEL-ID 
#@onready var bridges_built:Array[int] = []




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
	# debugging 
	check_input()
	#update_interactionLabel()


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
func execute_interaction():
	if not all_interactions.is_empty(): # interaction not empty
		
		# taking first element from interaction
		var active_interaction = all_interactions[0]
		
		# query result from obtained interation 
		var obtained_interaction: Interactable.InteractionValue = active_interaction.interact_with_area()
		match obtained_interaction.type:
			Interactable.InteractionType.BRIDGE: 
				print("entering bridge game") 
			Interactable.InteractionType.ITEM: 
				print("obtained item")
			Interactable.InteractionType.NPC:
				print("interacting with npc")
			Interactable.InteractionType.DEBUG:
				print("debug")
			_: 
				return 
		# we will match again a certain type
		match active_interaction.interact_type:
			Interactable.InteractionType.BRIDGE:
				print("entering bridge game")
				# drawing ID from Bridge-Interaction
				# FIXME maybe we should instead use a standardized interaction type?
				var resulting_dict: Dictionary = active_interaction.interact_with_area()
				
				print(resulting_dict["id"])
				set_interactionLabel(resulting_dict["description"])
				#enter_bridge_scene(bridge_id)
			Interactable.InteractionType.ITEM: 
				print("found an item")
				var resulting_dict: Dictionary = active_interaction.interact_with_area()
				set_interactionLabel(resulting_dict["dialogue"])
				add_to_inventory(resulting_dict["item"])
				#add_to_inventory(active_interaction.interact_value)
				# adding to inventory! 
			Interactable.InteractionType.NPC:
				print("npc interaction")
				
				var resulting_dict: Dictionary = active_interaction.interact_with_area()
				
				# entering dialogue, disable movement
				SingletonPlayer.enter_dialogue(resulting_dict["npc_id"])
				
				set_interactionLabel(resulting_dict["dialogue"])
				# FIXME requires enum "QUEST" to match against!
				# FIXME should be easier when done with separate **dialogue system**
				add_to_inventory(resulting_dict["value"])
			Interactable.InteractionType.DEBUG:
				print("debug interaction")
				pass
				
			_: #default
				pass


# checks against definde inputs, takes action if action was registered
# TODO naming could be improved
func check_input():
	if Input.is_action_just_pressed("interact_overworld"):
		execute_interaction()
	if Input.is_action_just_pressed("use_item"):
		#use_item()
		# FIXME debugging dialogue  --> resetting is_in_dialogue
		# TODO handled in Dialogue-System instead
		SingletonPlayer.exit_dialogue()
		set_interactionLabel("")
		pass
	if Input.is_action_just_pressed("open_menu"):
		enter_pause_menu()
		
	

# replaces inventory with given Array of items
# FIXME --> Singleton Conversion
func set_inventory(new_inventory:Dictionary):
	inventory = new_inventory
	updated_inventory.emit(inventory)
	

# takes new item and updates amount stored in inventory 
# if ItemType is "None" nothing will be changed 
# FIXME --> Singleton Conversion
func add_to_inventory(new_item:Item):
	if new_item.item_type != Item.ItemType.NONE:
		# we can verify that every item is constantly available!
		var selected_item = inventory[new_item.item_type]
		selected_item.increase_amount()
		# emit signal to update Ui
		updated_inventory.emit(inventory)
	# --> no item was received

# checks whether requested item is contained 
# returns true if it was and decreases amount by one
# returns false otherwise
# FIXME --> Singleton Conversion
func request_item(requested_item:Item) -> bool: 
	if inventory.has(requested_item.item_type):
		var item_instance:Item = inventory[requested_item.item_type]
		
		if item_instance.obtain_amount() >= 1:
			item_instance.set_amount(item_instance.obtain_amount() - 1)
			return true
		
	return false
	
	

# ---- 
# scene change management
# ---- 

func enter_pause_menu():
	print("pause menu")
	exit_overworld()
	# TODO 
	get_tree().change_scene_to_file("res://overworld/ui/menu/menu/pause_menu.tscn")

func enter_bridge_scene(bridge_id):
	print("entering bridge game", bridge_id)
	exit_overworld()
	# TODO search for bridgeGame with correct id! 
	# load it afterwards
	# enter_pause_menu() # default until we merged
	get_tree().change_scene_to_file("res://bridges/scenes/bridge_1.tscn")
	

# prepare player to leave overworld, store its state 
func exit_overworld():
	print("save user position")
	save_player()
	
# ---- 
#  saving player state
# ---- 

func save_player():
	print("save user position")
	saved_player.emit()
	
# TODO --> Singleton conversion!
func save_state():
	var json_inventory = []
	
	for item in inventory:
		var selected_item = inventory[item]
		var item_dictionary = selected_item.to_json()
		
		var item_amount = selected_item.obtain_amount()
		item_dictionary["amount"] = item_amount
		# store amount
		
		
		
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
	

