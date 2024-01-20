extends Control

func _on_retry_button_pressed():
	# reset everything
	var grid = get_parent()
	grid.get_node("Player").reset_player()
	Global.change_ui_visibility(true, grid)
	Global.reset_modes()
	get_parent().reset_grid()
	visible = false


func _on_continue_button_pressed():
	# reset global variables
	Global.reset_modes()
	# return to overworld scene
	get_tree().change_scene_to_file("res://overworld/main_scene_overworld.tscn")
	print("lets go to the overworld now")
