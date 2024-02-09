extends TextureRect

# either Deer_, Snake_, Spider_, or Squirrel_Item from the grid scene
var animal_item


# Called when the node enters the scene tree for the first time.
func _ready():
	animal_item = get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#The normal drag does not work with zoom so we do our own
	var global = get_global_mouse_position()
	Global.currently_dragging = true
	match tooltip_text:
		#We have to adjust the offset based on the animal
		# position needs to be in the middle of  a grid-square!
		"DEER":
			position = Vector2(global.x-15, global.y-25)
		"SNAKE":
			position = Vector2(global.x-25, global.y-5)
		"SPIDER":
			position = Vector2(global.x-5, global.y-5)
		"SQUIRREL":
			position = Vector2(global.x-5, global.y-15)
	if Input.is_action_just_released("click"):
		Global.currently_dragging = false
		queue_free()

# forward to grid_drag.gd
func _can_drop_data(at_position, data):
	return animal_item._can_drop_data(at_position, data)

# forward to grid_drag.gd
func _drop_data(at_position, data):
	animal_item._drop_data(at_position, data)
