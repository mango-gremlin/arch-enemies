extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#The normal drag does not work with zoom so we do our own
	var global = get_global_mouse_position()
	match tooltip_text:
		#We have to adjust the offset based on the animal
		"DEER":
			position = Vector2(global.x, global.y-40)
		"SNAKE":
			position = Vector2(global.x-42, global.y-5)
		"SPIDER":
			position = Vector2(global.x-100, global.y-10)
		"SQUIRREL":
			position = Vector2(global.x-110, global.y-20)
	if Input.is_action_just_released("click"):
		queue_free()
