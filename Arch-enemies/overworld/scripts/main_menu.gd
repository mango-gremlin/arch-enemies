extends Control



func _on_button_pressed():
	pass # Replace with function body.


func _on_options_pressed():
	pass # Replace with function body.


func _on_exit_pressed(): #quit
	get_tree().quit()


func _on_about_pressed(): #about
	get_tree().change_scene_to_file("res://overworld/ui/main_menu/about.tscn")


func _on_overworld_pressed():
	get_tree().change_scene_to_file("res://overworld/main_scene_overworld.tscn")
