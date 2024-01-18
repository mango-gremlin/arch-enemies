extends Area2D

class_name BridgeGoal

@export var valid_groups : Array[String] = ["BRIDGE_PLAYER"] 

signal reached

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(check_done)

func check_done(body : Node2D):
	for g in valid_groups:
		if body.is_in_group(g):
			reached.emit()
