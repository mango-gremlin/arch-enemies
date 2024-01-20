extends Area2D

signal play_sound()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# if fox comes in contact with goal zone
func _on_goal_area_2d_body_entered(_body):
	if _body != null and _body.is_in_group("player"):
		play_sound.emit()
		var goal_menu = get_parent().get_parent().find_child("goal_menu")
		goal_menu.visible = true
		


