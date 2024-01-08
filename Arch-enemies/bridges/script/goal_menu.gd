extends Control

func _on_retry_button_pressed():
	get_parent().get_node("player").reset_player()
	visible = false


func _on_continue_button_pressed():
	# TODO return to overworld scene
	#get_tree().change_scene_to_file("res://overworld/overworld.tscn")
	print("lets go to the overworld now")
