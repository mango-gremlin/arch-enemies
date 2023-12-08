extends Control

func _on_retry_button_pressed():
	get_parent().get_node("player").reset_player()
	visible = false


func _on_continue_button_pressed():
	print("lets go to the overworld now")
