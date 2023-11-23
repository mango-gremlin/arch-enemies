extends Node

class_name Game

# binding variables that are created by the player 
@export var ui:UI 
@export var player:Player

# Called when the node enters the scene tree for the first time.
func _ready():
	if!player.collision.is_connected(ui._on_collision):
		player.collision.connect(ui._on_collision)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
