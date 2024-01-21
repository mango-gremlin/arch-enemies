extends Control

func _ready():
	get_node("Cutscene1").visible = true


func _on_button_3_pressed():
	get_node("Cutscene3").visible = false
	get_tree().change_scene_to_file("res://overworld/main_scene_overworld.tscn")


func _on_button_2_pressed():
	get_node("Cutscene2").visible = false
	get_node("Cutscene3").visible = true


func _on_button_1_pressed():
	get_node("Cutscene1").visible = false
	get_node("Cutscene2").visible = true


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://overworld/main_scene_overworld.tscn")
