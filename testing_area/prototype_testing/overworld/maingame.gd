extends Node

@onready var player_object = $Player
@onready var Savemanager = Savemanagement.new(player_object)



# Called when the node enters the scene tree for the first time.
func _ready():
	Savemanager.load_config()
	#player_object.maingame = self
	
	# TODO add input to set 
	Savemanager.select_profile("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# function, called if player saves game
func _on_player_saved_player():
	Savemanager.save_config()
	#pass # Replace with function body.
