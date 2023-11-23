extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("something entered")
	if Input.is_action_pressed("interact_object"):
		print("pressed E inside")
		
