extends Area2D
class_name Interactable

# default value at interaction
@export var interact_label = "none"
# defines type of action, i.e item, shop, dialogue
@export var interact_type = "none"
# 
@export var interact_value = "no interaction"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
