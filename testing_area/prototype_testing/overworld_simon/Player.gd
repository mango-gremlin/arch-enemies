extends Node2D

@export var max_health : float = 10.0
@export var health : float = 10.0

var root = null #root node sets playerDied function
var uiElements = null #to set ui elements

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
var remoteTransformConfigured = false	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func playerPosition():
	return ($CharacterBody2D).position

func damagePlayer(damage = 1.0):
	print("damaged player")
	
	health -= damage
	
	if health <= 0 and health != null: #player died
		root.playerDied()
		return
		
	uiElements.updateHealthbar(health, max_health)
