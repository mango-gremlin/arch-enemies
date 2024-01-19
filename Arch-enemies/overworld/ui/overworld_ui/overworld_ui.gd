extends CanvasLayer

class_name OverWorldUI

#@onready var playername_label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/PlayerName
@onready var item_list_label = $Control/Items/VBoxContainer/HBoxContainer3/VBoxContainer/item_list
@onready var animal_list_label = $Control/Animals2/VBoxContainer/HBoxContainer4/VBoxContainer/animal_list
@onready var quest_list_label = $Control/Quests/VBoxContainer/quest_list


# Called when the node enters the scene tree for the first time.
func _ready():
	# connecting signal to singleton
	SingletonPlayer.connect("updated_item_inventory",_on_player_updated_inventory) 
	SingletonPlayer.connect("updated_animal_inventory",_on_animal_inventory_updated)
	SingletonPlayer.connect("updated_quest_list",_on_quest_list_updated)
	# initialize ui
	_update_item_inventory_label()
	_update_animal_inventory_label()


var player_item_inventory:Dictionary = {}:
	set(new_dict):
		# if a new array was given, we update its value, also the label
		player_item_inventory = new_dict
		_update_item_inventory_label()

var player_animal_inventory:Dictionary = {}:
	set(new_dict):
		player_animal_inventory = new_dict
		_update_animal_inventory_label()

var player_quest_dictionary:Dictionary = {}:
	set(new_dict):
		player_quest_dictionary = new_dict
		_update_quest_list()

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
	for animal:Animal.AnimalType in player_animal_inventory:
		var animal_amount:int = player_animal_inventory[animal]
		var animal_name:String = Animal.type_to_string(animal)
		label_string += str(animal_amount) + "x " + str(animal_name) + "\n"
	animal_list_label.text = label_string

# iterates over received list of quests
# displays them formatted in newline 
func _update_quest_list():
	var label_string:String = ""
	for quest_id:int in player_quest_dictionary:
		var quest_string:String = player_quest_dictionary[quest_id]
		
		label_string += quest_string + "\n"
	quest_list_label.text = label_string

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# updates the internal item_inventory upon signal received
func _on_player_updated_inventory(inventory):
	player_item_inventory = inventory

func _on_animal_inventory_updated(new_animal_inventory):
	player_animal_inventory = new_animal_inventory

func _on_quest_list_updated(new_quests):
	player_quest_dictionary = new_quests
