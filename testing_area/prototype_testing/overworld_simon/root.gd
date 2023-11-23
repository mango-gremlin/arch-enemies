extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = $Player
	player.root = self
	
	var hole = $MainMap/Hole
	hole.player = player
	
	var uiElements = $MainCam/UserInterfaceElements
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Function is called when player has health <= 0
func playerDied():
	print("killed player")
