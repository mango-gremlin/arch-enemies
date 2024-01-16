extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# if fox comes in contact with goal zone
func _on_goal_area_2d_body_entered(_body):
	if _body != null and _body.is_in_group("player"):
		var grid = get_parent().get_parent()
		var goal_menu = grid.find_child("goal_menu")
		goal_menu.visible = true
		Global.goal_reached = true
		# menu_mode is active when pause_menu is visible		
		Global.menu_mode = true
		Global.change_ui_visibility(false, grid)
		


