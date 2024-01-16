extends Control

signal level_solved

func _on_retry_button_pressed():
	get_parent().get_node("Player").reset_player()
	Global.drag_mode = true
	get_parent().reset_grid()
	visible = false


func _on_continue_button_pressed():
	# Update global inventory
	level_solved.emit()
	# Add bridge edge to Singleton, I used the values from Singleton.bridge_level_scenes
	#print("Build bridges for finish: ", SingletonPlayer.bridges_built)
	SingletonPlayer.add_bridge_connection(get_bridge_edge())
	#print("Build bridges after finish: ", SingletonPlayer.bridges_built)
	get_tree().change_scene_to_file("res://overworld/main_scene_overworld.tscn")

func get_bridge_edge():
	var levels = SingletonPlayer.bridge_level_scenes
	for level in levels:
		var path = levels[level]
		if path == get_tree().current_scene.scene_file_path:
			return levels.find_key(path)
		# TODO: create new entry?
