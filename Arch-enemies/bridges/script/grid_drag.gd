extends TextureRect

#Here we define the elements we need to operate on the grid
var grid = []
@export var square_size = 10
enum ENTITY_TYPES {GROUND, WATER, AIR, ANIMAL, FORBIDDEN, ALLOWED, SIDE, BOTTOM}
#We have to use our own preview scene because otherwise things are terrible
const DRAGPREVIEW = preload("res://bridges/scenes/dragpreview.tscn")

#And the signal we need to communicate with the grid
signal need_grid
signal update_grid(pos, data)
signal is_dragging
signal dragging_done

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
	dragging_done.emit()
	update_grid.emit(position, data)

func _on_grid_current_grid(current_grid):
	grid = current_grid

func is_snake_allowed(pos):
	var is_allowed = false
	var snake_head = [Vector2i(4, 1), Vector2i(5, 1), Vector2i(5, 0), Vector2i(5, -1), Vector2i(4, -1)]
	#For a cell to be legal we work from the bottom left corner of the animal
	#And check each square of the grid cell that would in the sprite
	if(grid[pos.x][pos.y] == ENTITY_TYPES.ALLOWED):
		var is_free = true
		for delta in range(1, 5):
			#If it is AIR (i.e. empty) or ALLOWED we are good
			if(not (grid[pos.x + delta][pos.y] == ENTITY_TYPES.AIR or 
			grid[pos.x + delta][pos.y] == ENTITY_TYPES.ALLOWED)):
				#Otherwise we are not
				is_free = false
				break
		if(is_free):
			is_allowed = true
	for position in snake_head:
		if(grid[pos.x + position.x][pos.y + position.y] == ENTITY_TYPES.ANIMAL):
			is_allowed = false
	return is_allowed

func is_spider_allowed(pos):
	#This works just like Snake
	var is_allowed = false
	if(grid[pos.x][pos.y] == ENTITY_TYPES.ALLOWED 
	or grid[pos.x][pos.y] == ENTITY_TYPES.SIDE or grid[pos.x][pos.y] == ENTITY_TYPES.BOTTOM):
		is_allowed = true
	return is_allowed

func is_deer_allowed(pos):
	var is_allowed = false
	#The Deer has empty slots in it sprite, it is allowed for them to have something in them
	var allowed = [Vector2i(0, 3), Vector2i(3, 0), Vector2i(3, 1), Vector2i(3, 2)]
	if(grid[pos.x][pos.y] == ENTITY_TYPES.ALLOWED):
		var is_free = true
		for delta in range(4):
			for epsilon in range(4):
				if(not (grid[pos.x + delta][pos.y - epsilon] == ENTITY_TYPES.AIR or 
				grid[pos.x + delta][pos.y - epsilon] == ENTITY_TYPES.ALLOWED)):
					#Therefore we only flag the squares which are not in allowed
					if(Vector2i(delta, epsilon) not in allowed):
						is_free = false
						break
		if(is_free):
			is_allowed = true
	return is_allowed

func is_squirrel_allowed(pos):
	#Check if one tile is in necessary ALLOWED or SIDE and if all other tiles are free
	var is_allowed = false
	var is_free = true
	for epsilon in range(2):
		var pos_Type = grid[pos.x][pos.y-epsilon]
		if(pos_Type == ENTITY_TYPES.ALLOWED or pos_Type == ENTITY_TYPES.SIDE):
			is_allowed = true
		if(pos_Type == ENTITY_TYPES.FORBIDDEN or pos_Type == ENTITY_TYPES.GROUND or
			pos_Type == ENTITY_TYPES.WATER or pos_Type == ENTITY_TYPES.ANIMAL):
			is_free = false
	return is_allowed and is_free
