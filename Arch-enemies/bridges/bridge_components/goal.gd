extends Area2D

signal play_sound()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# if fox comes in contact with goal zone
func _on_goal_area_2d_body_entered(_body):
	if _body != null and _body.is_in_group("player"):
		var grid = get_parent().get_parent()
		var goal_menu = grid.find_child("goal_menu")
		play_sound.emit()
		goal_menu.visible = true
		Global.walking = false
		grid.goal_reached = true
		# menu_mode is active when goal is reached
		grid.menu_mode = true
		grid.change_ui_visibility()
		


