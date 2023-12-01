extends CharacterBody2D

signal updated_inventory(new_inventory)

@export var SPEED = 100
@export var zoomlevel:Vector2 = Vector2(1,1)
@onready var anim :  AnimatedSprite2D = $AnimatedSprite2D
@onready var inventory:Array = []

# collects all interactions that we currently have 
# Queue-like structure 
@onready var all_interactions = []
@onready var interactionLabel = $interactioncomponents/InteractLabel


func _ready():
	#debug 
	update_interactionLabel()

func _physics_process(delta):
	player_movement(delta)
	# checking for interaction in world
	# debugging 
	check_input()
	update_interactionLabel()


func player_movement(delta):
	
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
# --- structure for interaction with Areas
# -----

 
func _on_interactionarea_area_entered(area):
	# we enter a new interaction into our list 
	all_interactions.insert(0,area)


func _on_interactionarea_area_exited(area):
	all_interactions.erase(area)
	

func execute_interaction():
	if all_interactions:
		# drawing first element from interaction
		var active_interaction = all_interactions[0]
		# we will match again a certain type
		match active_interaction.interact_type:
			"bridge_game":
				print("entering bridge game")
				enter_pause_menu()
			"findStone": 
				print("found a stone!")
				print(active_interaction.interact_value)
				# adding to inventory! 
				updateInventory("stone")
			"findStick":
				print("found a stick!")
				print(active_interaction.interact_value)
				updateInventory("stick")
			_: #default
				pass
			

func use_item():
	# TODO could use pattern matching to use the item accordingly
	if !inventory.is_empty():
		# inventory not empty, using item
		var used_item = inventory.pop_at(0)
		
		# TODO as long as this is a string, we can use this as debug
		print(used_item)
		# update UI
		updated_inventory.emit(inventory)

func check_input():
	if Input.is_action_just_pressed("interact_overworld"):
		execute_interaction()
	if Input.is_action_just_pressed("use_item"):
		use_item()
	if Input.is_action_just_pressed("open_menu"):
		enter_pause_menu()
		
	

# this ought to improve, use enums or similar for patter matching
func updateInventory(item:String):
	inventory.insert(0,item)
	# emit signal to update Ui
	updated_inventory.emit(inventory)

func enter_pause_menu():
	print("pause menu")
	exit_overworld()
	get_tree().change_scene_to_file("res://ui/menu/pause_menu.tscn")

func exit_overworld():
	# TODO save coordinates
	# TODO save state in file!
	# TODO save Inventory 
	print("save user position")
	saveState()
	
func saveState():
	var state = {
		#"filename", get_scene_file_path(), 
		"name" : name,
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"inventory": inventory
	}
	return state
	
# ----- 
# debugging
# ----- 
func update_interactionLabel():
	if all_interactions:
		# taking active interaction and insert its label --> descriptions
		interactionLabel.text = all_interactions[0].interact_label
	else:
		interactionLabel.text = ""
