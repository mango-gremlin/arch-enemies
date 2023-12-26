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
		_update_inventory_label()

func _update_inventory_label():
	# iterate over item
	var newString:String  = ""
	for item in player_item_inventory:
		var selected_item = player_item_inventory[item]
		
		#if amount == 0:
		#	continue
		var item_amount = selected_item.obtain_amount()
		var item_name = selected_item.obtain_name()
		#var item_description = selected_item.obtain_item_description()
		newString += str(item_amount) + "x " + str(item_name) + "\n"
	item_list_label.text = newString

# Called when the node enters the scene tree for the first time.
func _ready():
	# connecting signal to singleton
	SingletonPlayer.connect("updated_item_inventory",_on_player_updated_inventory) 
	# initialize ui
	_update_inventory_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# updates the internal item_inventory upon signal received
func _on_player_updated_inventory(inventory):
	player_item_inventory = inventory
	
