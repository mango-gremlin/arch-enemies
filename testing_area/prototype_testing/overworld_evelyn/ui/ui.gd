extends CanvasLayer
class_name UI

@onready var health_label = $Control/MarginContainer/VBoxContainer/HBoxContainer/health
@onready var name_label  = $Control/MarginContainer/VBoxContainer/HBoxContainer2/name

var health = 100:
	set(updatedHealth):
		health = updatedHealth
		updateHealth_Label()

var playername="noname":
	set(updatedName):
		name = updatedName
		updateNameLabel()

func updateNameLabel() -> void:
	name_label = playername
	

func _on_collision() -> void:
		health -= 10

func updateHealth_Label() -> void:
	health_label.text = str(health)
# Called when the node enters the scene tree for the first time.


func _ready():
	# initialize with default values
	updateHealth_Label()
	updateNameLabel()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
