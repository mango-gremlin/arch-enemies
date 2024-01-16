extends Node

# for ysort to work, player needs to be child of tilemap, so Player has a different position
#@onready var player_object = $world/TileMap/Player
#@onready var Savemanager = Savemanagement.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	SingletonPlayer.signal_inventory_update_ui()
	#Savemanager.load_config()
	#player_object.maingame = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# function, called if player saves game
func _on_player_saved_player():
	#Savemanager.save_config()
	pass # Replace with function body.
