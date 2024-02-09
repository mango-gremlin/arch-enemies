extends TextureRect

#Here we define the elements we need to operate on the grid
var grid = [[]]
@export var square_size = 10
enum ENTITY_TYPES {GROUND, WATER, AIR, ANIMAL, FORBIDDEN, ALLOWED, SIDE, BOTTOM, SHALLOW}
#We have to use our own preview scene because otherwise things are terrible
const DRAGPREVIEW = preload("res://bridges/scenes/dragpreview.tscn")

#And the signal we need to communicate with the grid
signal need_grid
signal update_grid(pos, data)
signal is_dragging
signal play_sound(sound)

# required to load and interact with scene-specific inventory
# this acts as reference to the animal inventory stored in "GRID"
@onready var animal_inventory_reference:Dictionary
@export var Grid_node_reference:TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	# take animal inventory from parent-Grid tilemap
	animal_inventory_reference = Grid_node_reference.start_animals
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _get_drag_data(_at_position):
	# check for drag mode and if trying to drag an animal
	if Global.drag_mode and tooltip_text != "":
		# First we need to check if we have some animals of the requested type left in the inventory
		var animal = tooltip_text 
		# Due to we use the tooltip we need to check if the string is valid... this is not secure for typos!
		var animal_type:Animal.AnimalType = Animal.string_to_type(animal)
		if animal != "" and Grid_node_reference.start_animals[animal_type] <= 0:
			return
		
		# When we try to drag something we first need to know what the grid looks like
		need_grid.emit()
		#Then we tell the grid that we are currently dragging something
		#This allows us to see FORBIDDEN and ALLOWED zones
		is_dragging.emit()
		
		# We create the data we want to transmit
		var data = {}
		# And the preview that is shown as we move the cursor
		var preview = DRAGPREVIEW.instantiate()
		
		# The texture of the TRect
		var sprite = texture
		
		#This adds a control node that allows us to fix the position of the preview
		var c = Control.new()
		c.add_child(preview)
		
		if(sprite != null):
			#If we are not trying to drag the TRect that represent the grid we create the preview
			preview.expand = true
			preview.texture = sprite
			#We also emit the appropiate sound
			play_sound.emit(animal)
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
			#this must be in the if case, otherwise we instantiate the drag_grid
			add_child(c)

		data["sprite"] = sprite
		data["animal"] = animal
		return data

func _can_drop_data(_at_position, data):
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

func _drop_data(_at_position, data):
	#The dropping itself is simple
	#We just return the position to the grid and update it
	var position = Vector2(int(get_global_mouse_position().x /square_size), 
	int(get_global_mouse_position().y /square_size))
	update_grid.emit(position, data)
	#Also play the appropiate sound
	play_sound.emit("DROP")

func _on_grid_current_grid(current_grid):
	grid = current_grid
	
func is_snake_allowed(pos):
	pos.x -= 2 # middle offset
	if(in_bound(pos, 5, 1)):
		return false
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
	if(in_bound(pos, 1, 1)):
		return false
	if(pos.x > grid.size() or pos.y > grid[0].size()):
		return false
	var pos_Type = grid[pos.x][pos.y]
	var is_allowed_and_free = pos_Type == ENTITY_TYPES.ALLOWED \
		or pos_Type == ENTITY_TYPES.SIDE or pos_Type == ENTITY_TYPES.BOTTOM
	return is_allowed_and_free
	
func is_deer_allowed(pos):
	# middle offset
	pos.x -= 1
	pos.y += 1
	if(in_bound(pos, 4, 4)):
		return false
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
				if(pos_Type == ENTITY_TYPES.ALLOWED or pos_Type == ENTITY_TYPES.SHALLOW):
					is_allowed = true
				#Is there space for the animal?	
				if(pos_Type == ENTITY_TYPES.FORBIDDEN or pos_Type == ENTITY_TYPES.GROUND or 
				pos_Type == ENTITY_TYPES.WATER or pos_Type == ENTITY_TYPES.ANIMAL):
					is_free = false
	return is_allowed and is_free

func is_squirrel_allowed(pos):
	if(in_bound(pos, 1, 2)):
		return false
	var is_allowed = false
	var is_free = true
	for epsilon in range(2):
		var pos_Type = grid[pos.x][pos.y-epsilon]
		#Is there something to attach the animal to?
		if(pos_Type == ENTITY_TYPES.ALLOWED or pos_Type == ENTITY_TYPES.SIDE):
			is_allowed = true
		#Is there space for the animal?
		if(pos_Type == ENTITY_TYPES.FORBIDDEN 
			or pos_Type == ENTITY_TYPES.GROUND 
			or pos_Type == ENTITY_TYPES.WATER 
			or pos_Type == ENTITY_TYPES.ANIMAL 
			or pos_Type == ENTITY_TYPES.SHALLOW):
			is_free = false
	return is_allowed and is_free
	
func in_bound(pos, off_x, off_y):
	var max_x = grid.size() - 1
	var max_y = grid[0].size() - 1
	#First we check if it is not above or to the left of the screen
	var bound = pos.x > 0 and pos.y > 0 
	#Second we do the same for below or right of the screen
	bound = bound and pos.x < max_x and pos.y < max_y 
	#Finally we check if the sprite stretches out of the screen
	bound = bound and pos.x + off_x <= max_x 
	bound = bound and pos.y - off_y >= 0
	return not bound
