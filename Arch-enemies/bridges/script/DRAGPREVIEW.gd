extends TextureRect
var rotation_state = 0
var offset_x
var offset_y

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var global = get_global_mouse_position()
	if Input.is_action_just_pressed("rotate"):
		rotation_state = (rotation_state + 1) % 4
	#The normal drag does not work with zoom so we do our own
	match tooltip_text:
		#We have to adjust the offset based on the animal
		"DEER":
			match rotation_state:
				0:
					offset_x = 0
					offset_y = 40
					flip_h = false
					flip_v = false
				1:
					offset_x = 0
					offset_y = 0
					flip_h = false
					flip_v = true
				2:
					offset_x = 40
					offset_y = 0
					flip_h = true
					flip_v = true
				3:
					offset_x = 40
					offset_y = 40
					flip_h = true
					flip_v = false
		"SNAKE":
			match rotation_state:
				0:
					offset_x = 45
					offset_y = 10
					flip_h = false
					flip_v = false
				1:
					offset_x = 35
					offset_y = 0
					flip_h = false
					flip_v = false
				2:
					offset_x = 45
					offset_y = -10
					flip_h = false
					flip_v = true
				3:
					offset_x = 55
					offset_y = 0
					flip_h = false
					flip_v = false
			rotation_degrees = rotation_state * 90
		"SPIDER":
			offset_x = 100
			offset_y = 10
		"SQUIRREL":
			match rotation_state:
				0:
					offset_x = 110
					offset_y = 20
				1:
					offset_x = 90
					offset_y = 0
				2:
					offset_x = 110
					offset_y = -20
				3:
					offset_x = 130
					offset_y = 0
			rotation_degrees = rotation_state * 90

	position = Vector2(global.x - offset_x, global.y - offset_y)
	if Input.is_action_just_released("click"):
		queue_free()

