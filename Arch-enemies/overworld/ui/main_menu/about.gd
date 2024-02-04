extends Control

signal play_sound(sound_type)

func _on_button_pressed():
	play_sound.emit("CLICK")
	get_tree().change_scene_to_file("res://overworld/ui/main_menu/main_menu.tscn")


func _on_licensing_pressed():
	play_sound.emit("CLICK")
	get_tree().change_scene_to_file("res://overworld/ui/main_menu/licensing.tscn")


func _on_link_button_pressed():
	play_sound.emit("CLICK")
	


func _on_link_button_2_pressed():
	play_sound.emit("CLICK")
