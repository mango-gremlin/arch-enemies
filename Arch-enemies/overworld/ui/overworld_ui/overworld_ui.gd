extends CanvasLayer

class_name OverWorldUI

@onready var quest_list_label = $Control/QuestsAndQuestBox/quest_list

#@onready var playername_label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/PlayerName
# these two are technically redundant
@onready var item_list_label = $Control/Items/VBoxContainer/HBoxContainer3/VBoxContainer/item_list
@onready var animal_list_label = $Control/Animals2/VBoxContainer/HBoxContainer4/VBoxContainer/animal_list

# unfortunately the fastest way here is just to save the path to each label

# item labels
@onready var egg_number = $Control/Items/VBoxContainer/GridContainer/egg_number
@onready var evidence_number = $Control/Items/VBoxContainer/GridContainer/evidence_number
@onready var fly_number = $Control/Items/VBoxContainer/GridContainer/fly_number
@onready var hazelnut_number = $Control/Items/VBoxContainer/GridContainer/hazelnut_number

# animal labels
@onready var deer_number = $Control/Animals2/Animals/deer_number
@onready var snake_number = $Control/Animals2/Animals/snek_number
@onready var squirrel_number = $Control/Animals2/Animals/squirrel_number
@onready var spider_number = $Control/Animals2/Animals/spider_number

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

# iterates over each item type and displays how many of each
func _update_item_inventory_label():
	# iterate over item
	for item in player_item_inventory:
		var item_string:String  = ""
		var item_amount:int = player_item_inventory[item]
		var item_label
		
		item_string += str(item_amount) + "x "
		
		match item:
			Item.ItemType.EVIDENCE:
				item_label = evidence_number
			Item.ItemType.EGG:
				item_label = egg_number
			Item.ItemType.HAZELNUT:
				item_label = hazelnut_number
			Item.ItemType.FLIES:
				item_label = fly_number
			_:
				item_label = evidence_number
		
		item_label.text = item_string

# iterates over each animal type and displays how many of each
func _update_animal_inventory_label():
	
	for animal:Animal.AnimalType in player_animal_inventory:
		var label_string:String = ""
		var animal_amount:int = player_animal_inventory[animal]
		var label
		
		label_string += str(animal_amount) + "x "
		
		match animal:
			Animal.AnimalType.DEER:
				label = deer_number
			Animal.AnimalType.SNAKE:
				label = snake_number
			Animal.AnimalType.SQUIRREL:
				label = squirrel_number
			Animal.AnimalType.SPIDER:
				label = spider_number
			Animal.AnimalType.NONE:
				label = animal_list_label
		
		label.text = label_string

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
