extends Control

signal level_solved
signal play_sound(sound_type)

func _on_retry_button_pressed():
	# reset everything
	var grid = get_parent()
	grid.get_node("Player").reset_player()
	grid.change_ui_visibility()
	grid.reset_modes()
	get_parent().reset_grid()
	visible = false
	play_sound.emit("CLICK")


func _on_continue_button_pressed():
	# reset global variables
	get_parent().reset_modes()
	# Update global inventory
	level_solved.emit()
	# Add bridge edge to Singleton
	var current_edge = SingletonPlayer.get_current_bridge_edge()
	SingletonPlayer.add_bridge_connection(current_edge)
	#SingletonPlayer.set_current_bridge_edge(null)
	get_tree().change_scene_to_file("res://overworld/main_scene_overworld.tscn")
	play_sound.emit("CLICK")

func _on_back_button_pressed():
	#reset everthing except the placed animals
	var grid = get_parent()
	grid.get_node("Player").reset_player()
	grid.change_ui_visibility()
	grid.reset_modes()
	visible = false
	play_sound.emit("CLICK")
