extends Control

signal level_solved

func _on_retry_button_pressed():
	# reset everything
	var grid = get_parent()
	grid.get_node("Player").reset_player()
	grid.change_ui_visibility(true)
	grid.reset_modes()
	get_parent().reset_grid()
	visible = false


func _on_continue_button_pressed():
	# reset global variables
	get_parent().reset_modes()
	# return to overworld scene
	# Update global inventory
	level_solved.emit()
	# Add bridge edge to Singleton
	var current_edge = SingletonPlayer.get_current_bridge_edge()
	SingletonPlayer.add_bridge_connection(current_edge)
	#SingletonPlayer.set_current_bridge_edge(null)
	get_tree().change_scene_to_file("res://overworld/main_scene_overworld.tscn")
