extends CanvasLayer

class_name OverWorldUI

@onready var health_label = $Control/MarginContainer/VBoxContainer/HBoxContainer/Health
@onready var playername_label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/PlayerName
@onready var quest_label = $Control/MarginContainer/VBoxContainer/HBoxContainer3/VBoxContainer/QuestList

var current_quests:Array = ["hello!","world?"]:
	set(newArray):
		# if a new array was given, we update its value, also the label
		current_quests = newArray
		_update_quest_label()

var current_health:int = 100:
	set(updatedHealth):
		current_health = updatedHealth
		_update_health_label()

func _update_quest_label():
	# iterate over item
	var newString:String  = ""
	for quest_string in current_quests:
		newString += str(quest_string) + "\n"
	quest_label.text = newString

func _update_health_label(): 
	health_label.text = str(current_health)

# Called when the node enters the scene tree for the first time.
func _ready():
	# initializing UI accordingly
	_update_health_label()
	# not sure whether we should call  and always set this here?
	playername_label.text = "Eve"
	
	_update_quest_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_updated_inventory(inventory):
	current_quests = inventory
	
