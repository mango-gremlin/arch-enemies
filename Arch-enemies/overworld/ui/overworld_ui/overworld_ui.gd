extends CanvasLayer

class_name OverWorldUI

@onready var health_label = $Control/MarginContainer/VBoxContainer/HBoxContainer/Health
@onready var playername_label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/PlayerName
@onready var quest_label = $Control/MarginContainer/VBoxContainer/HBoxContainer3/VBoxContainer/QuestList

var player_inventory:Dictionary = {}:
	set(newDict):
		# if a new array was given, we update its value, also the label
		player_inventory = newDict
		_update_inventory_label()

var current_health:int = 100:
	set(updatedHealth):
		current_health = updatedHealth
		_update_health_label()

func _update_inventory_label():
	# iterate over item
	var newString:String  = ""
	for item in player_inventory:
		var amount = player_inventory[item]
		
		if amount == 0:
			continue
		
		var item_name = item.item_name
		var item_description = item.item_description
		newString += str(amount) + "x " + str(item_name) + "\n"
	quest_label.text = newString

func _update_health_label(): 
	health_label.text = str(current_health)

# Called when the node enters the scene tree for the first time.
func _ready():
	# initializing UI accordingly
	_update_health_label()
	# not sure whether we should call  and always set this here?
	playername_label.text = "Eve"
	
	_update_inventory_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_updated_inventory(inventory):
	player_inventory = inventory
	
