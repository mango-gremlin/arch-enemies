extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_overworld_pressed():
	# TODO improve  by constantly saving the previous scene in a variable!
	get_tree().change_scene_to_file("res://maingame.tscn")


func _on_exit_pressed():
	# exit game
	get_tree().quit()
