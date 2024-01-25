extends Control


func _on_button_pressed():
	get_tree().change_scene_to_file("res://overworld/ui/main_menu/main_menu.tscn")
