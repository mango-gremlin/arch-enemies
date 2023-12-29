extends CanvasLayer

class_name OverWorldUI

@onready var playername_label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/PlayerName
@onready var item_list_label = $Control/MarginContainer/VBoxContainer/HBoxContainer3/VBoxContainer/item_list
@onready var animal_list_label = $Control/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/animal_list
@onready var quest_list_label = $Control/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer/quest_list

# FIXME remove internal representation 
# --> We only need one reference to the actual dictionary containing the information
var player_item_inventory:Dictionary = {}:
	set(newDict):
		# if a new array was given, we update its value, also the label
		player_item_inventory = newDict
		_update_item_inventory_label()

var player_animal_inventory:Dictionary = {}:
	set(newDict):
		player_animal_inventory = newDict
		_update_animal_inventory_label()

func _update_item_inventory_label():
	# iterate over item
	var item_string:String  = ""
	for item in player_item_inventory:
		var item_amount:int = player_item_inventory[item]
		var item_name:String = Item.item_type_to_string(item)
		item_string += str(item_amount) + "x " + str(item_name) + "\n"
	item_list_label.text = item_string

# iteratesover each animaltyp and display their properties
func _update_animal_inventory_label():
	var label_string:String = ""
	for animal:SingletonPlayer.AnimalType in player_animal_inventory:
		var animal_amount:int = player_animal_inventory[animal]
		var animal_name:String = ""
		label_string += str(animal_amount) + "x " + str(animal_name) + "\n"
	animal_list_label.text = label_string
		
		
	

# Called when the node enters the scene tree for the first time.
func _ready():
	# connecting signal to singleton
	SingletonPlayer.connect("updated_item_inventory",_on_player_updated_inventory) 
	SingletonPlayer.connect("updated_animal_inventory",_on_animal_inventory_updated)
	# initialize ui
	_update_item_inventory_label()
	_update_animal_inventory_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# updates the internal item_inventory upon signal received
func _on_player_updated_inventory(inventory):
	player_item_inventory = inventory

func _on_animal_inventory_updated(new_animal_inventory):
	player_animal_inventory = new_animal_inventory
