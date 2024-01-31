extends Control

signal play_sound(sound_type)

# open settings menu as new scene
func _on_options_pressed():
	play_sound.emit("CLICK")
	get_tree().change_scene_to_file("res://overworld/ui/menu/menu/settings_menu.tscn")

# quit game entirely
func _on_exit_pressed():
	play_sound.emit("CLICK")
	get_tree().quit()

# open about page as new scene
func _on_about_pressed():
	play_sound.emit("CLICK")
	get_tree().change_scene_to_file("res://overworld/ui/main_menu/about.tscn")

# open overworld as new scene
func _on_overworld_pressed():
	play_sound.emit("CLICK")
	get_tree().change_scene_to_file("res://overworld/starting_cutscene.tscn")
