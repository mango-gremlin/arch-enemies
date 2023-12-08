extends Sprite2D


# if an object is being dragged, show grid
func _process(delta):
	load("res://bridges/global.gd")
	if Global.something_is_being_dragged:
		visible = true
	else:
		visible = false
	pass
