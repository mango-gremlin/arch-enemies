extends TextureRect

#Here we define the elements we need to operate on the grid
var grid = []
@export var square_size = 10
enum ENTITY_TYPES {GROUND, WATER, AIR, ANIMAL, FORBIDDEN, ALLOWED, SIDE, BOTTOM, SHALLOW}
#We have to use our own preview scene because otherwise things are terrible
const DRAGPREVIEW = preload("res://bridges/scenes/dragpreview.tscn")

#And the signal we need to communicate with the grid
signal need_grid
signal update_grid(pos, data)
signal is_dragging

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_drag_data(at_position):
	if Global.drag_mode:
		#When we try to drag something we first need to know what the grid looks like
		need_grid.emit()
		#Then we tell the grid that we are currently dragging something
		#This allows us to see FORBIDDEN and ALLOWED zones
		is_dragging.emit()
		
		#We create the data we want to transmit
		var data = {}
		#And the preview that is shown as we move the cursor
		var preview = DRAGPREVIEW.instantiate()
		
		#These are the two things we save in the data:
		#1) The texture of the TRect
		var sprite = texture
		#2) And the Tooltip, which identifies the animal
		var animal = tooltip_text 
		
		#This adds a control node that allows us to fix the position of the preview
		var c = Control.new()
		c.add_child(preview)
		
		if(sprite != null):
			#If we are not trying to drag the TRect that represent the grid we create the preview
			preview.expand = true
			preview.texture = sprite
			#The actualy size of the sprite depends on the animal, this is what the "animal" var is used
			#for, to identify the animal.
			match animal:
				"DEER":
					preview.set_size(Vector2(40, 40))
					preview.tooltip_text = "DEER"
				"SNAKE":
					preview.set_size(Vector2(50, 10))
					preview.tooltip_text = "SNAKE"
				"SPIDER":
					preview.set_size(Vector2(10, 10))
					preview.tooltip_text = "SPIDER"
				"SQUIRREL":
					preview.set_size(Vector2(10, 20))
					preview.tooltip_text = "SQUIRREL"
		
		c.set_global_position(Vector2i(0, 0))
		
		add_child(c)
		
		data["sprite"] = sprite
		data["animal"] = animal
		return data

func _can_drop_data(at_position, data):
	#To check if we can drop we need to check the grid
	#The Mouse is on a pixel base, while the grid has 10x10 cells
	#Therefore we convert
	var position = get_global_mouse_position()
	var y = int(position.y/square_size)
	var x = int(position.x/square_size)
	var pos = Vector2i(x, y)
	var is_allowed = false
	var animal = data["animal"]
	
	#Here we check for a given animal with its own sub-function if the grid cell is legal
	match animal:
		"DEER":
			is_allowed = is_deer_allowed(pos)
		"SNAKE":
			is_allowed = is_snake_allowed(pos)
		"SPIDER":
			is_allowed = is_spider_allowed(pos)	
		"SQUIRREL":
			is_allowed = is_squirrel_allowed(pos)
	
	return is_allowed

func _drop_data(at_position, data):
	#The dropping itself is simple
	#We just return the position to the grid and update it
	var position = Vector2(int(get_global_mouse_position().x /square_size), 
	int(get_global_mouse_position().y /square_size))
	update_grid.emit(position, data)

func _on_grid_current_grid(current_grid):
	grid = current_grid
	
func is_snake_allowed(pos):
	var is_allowed = false
	var is_free = true
	var head_free = true
	for delta in range(5):
		var pos_Type = grid[pos.x+delta][pos.y]
		#Is there something to attach the animal to?
		if(pos_Type == ENTITY_TYPES.ALLOWED):
			is_allowed = true
		#Is there space for the animal?	
		if(pos_Type == ENTITY_TYPES.FORBIDDEN or pos_Type == ENTITY_TYPES.GROUND
		or pos_Type == ENTITY_TYPES.WATER or pos_Type == ENTITY_TYPES.ANIMAL):
			is_free = false
	var snake_head = [Vector2i(4, 1), Vector2i(5, 1), Vector2i(5, 0), Vector2i(5, -1), Vector2i(4, -1)]
	for tile in snake_head:
		var pos_Type = grid[pos.x+tile.x][pos.y-tile.y]
		#Are there animals around the head of the snake?
		if(pos_Type == ENTITY_TYPES.ANIMAL):
			head_free = false
	return is_allowed and is_free and head_free

func is_spider_allowed(pos):
	var pos_Type = grid[pos.x][pos.y]
	var is_allowed_and_free = pos_Type == ENTITY_TYPES.ALLOWED \
		or pos_Type == ENTITY_TYPES.SIDE or pos_Type == ENTITY_TYPES.BOTTOM
	return is_allowed_and_free
	
func is_deer_allowed(pos):
	var is_allowed = false 
	var is_free = true 
	#The empty slots in the deer sprite
	var ignore = [Vector2i(0, 3), Vector2i(3, 0), Vector2i(3, 1), Vector2i(3, 2)]
	for delta in range(4):
		for epsilon in range(4):
			#Some slots need to be ignored
			if(Vector2i(delta,epsilon) not in ignore):
				var pos_Type = grid[pos.x+delta][pos.y-epsilon]
				#Is there something to attach the animal to?
				if(pos_Type == ENTITY_TYPES.ALLOWED):
					is_allowed = true
				#Is there space for the animal?	
				if(pos_Type == ENTITY_TYPES.FORBIDDEN or pos_Type == ENTITY_TYPES.GROUND or 
				pos_Type == ENTITY_TYPES.WATER or pos_Type == ENTITY_TYPES.ANIMAL):
					is_free = false
	return is_allowed and is_free

func is_squirrel_allowed(pos):
	var is_allowed = false
	var is_free = true
	for epsilon in range(2):
		var pos_Type = grid[pos.x][pos.y-epsilon]
		#Is there something to attach the animal to?
		if(pos_Type == ENTITY_TYPES.ALLOWED or pos_Type == ENTITY_TYPES.SIDE):
			is_allowed = true
		#Is there space for the animal?	
		if(pos_Type == ENTITY_TYPES.FORBIDDEN or pos_Type == ENTITY_TYPES.GROUND or
			pos_Type == ENTITY_TYPES.WATER or pos_Type == ENTITY_TYPES.ANIMAL):
			is_free = false
	return is_allowed and is_free
