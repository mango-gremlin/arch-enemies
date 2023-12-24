extends CanvasLayer

class_name OverWorldUI

@onready var playername_label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/PlayerName
@onready var item_list_label = $Control/MarginContainer/VBoxContainer/HBoxContainer3/VBoxContainer/item_list
@onready var animal_list_label = $Control/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/animal_list
@onready var quest_list_label = $Control/MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer/quest_list

var player_inventory:Dictionary = {}:
	set(newDict):
		# if a new array was given, we update its value, also the label
		player_inventory = newDict
		_update_inventory_label()

func _update_inventory_label():
	# iterate over item
	var newString:String  = ""
	for item in player_inventory:
		var selected_item = player_inventory[item]
		
		#if amount == 0:
		#	continue
		var item_amount = selected_item.obtain_amount()
		var item_name = selected_item.obtain_name()
		#var item_description = selected_item.obtain_item_description()
		newString += str(item_amount) + "x " + str(item_name) + "\n"
	item_list_label.text = newString

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# initialize ui
	_update_inventory_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#FIXME use to update UI every frame? 
	# --> might be too much work for nothing, 
	# instead -> only update whenever inventory changed!
	pass


func _on_player_updated_inventory(inventory):
	player_inventory = inventory
	
