extends TileMap

#We define the basical variables here

#Like the Tile Size
var tile_size = tile_set.tile_size

#The Dimensions of the Grid
var x_size = 115
var y_size = 65

#And finally some values we need later
var grid_size = Vector2(x_size, y_size)
var grid = []
var start_grid = [[[]]]
var last_states = []
var save_states = 10
var state = 0

#We have to define what parts of the tile-set are ground/water
var ground = [Vector2i(7, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1),
Vector2i(5, 1), Vector2i(7, 1), Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2),
Vector2i(4, 2), Vector2i(5, 2), Vector2i(6, 2), Vector2i(7, 2), Vector2i(1, 3), Vector2i(2, 3), 
Vector2i(3, 3), Vector2i(4, 3), Vector2i(5, 3), Vector2i(6, 3), Vector2i(7, 3), Vector2i(1, 4), 
Vector2i(2, 4), Vector2i(3, 4), Vector2i(0, 5), Vector2i(0, 6), Vector2i(0, 7), Vector2i(4, 5), 
Vector2i(4, 6), Vector2i(4, 7), Vector2i(5, 5), Vector2i(5, 6), Vector2i(5, 7), Vector2i(7, 6),
Vector2i(1, 8), Vector2i(2, 8), Vector2i(3, 8), Vector2i(6, 8), Vector2i(6, 9)]

var water = [Vector2i(7, 4), Vector2i(8, 4), Vector2i(8, 5), Vector2i(8, 6), Vector2i(6, 6), 
Vector2i(6, 7), Vector2i(1, 5), Vector2i(2, 5), Vector2i(3, 5), Vector2i(1, 6), Vector2i(2, 6), 
Vector2i(3, 6), Vector2i(1, 7), Vector2i(2, 7), Vector2i(3, 7), Vector2i(0, 8), Vector2i(0, 9),
Vector2i(1, 9), Vector2i(2, 9), Vector2i(3, 9), Vector2i(4, 9), Vector2i(7, 7), Vector2i(8, 7),
Vector2i(7, 8), Vector2i(8, 8), Vector2i(7, 9), Vector2i(8, 9), Vector2i(5, 8), Vector2i(5, 9)]

#And the start zone for the Fox
var fox_start = [Vector2(4, 50), Vector2(5, 50), Vector2(6, 50), Vector2(7, 50), Vector2(8, 50),
				Vector2(4, 49), Vector2(5, 49), Vector2(6, 49), Vector2(7, 49), Vector2(8, 49), 
				Vector2(4, 48), Vector2(5, 48), Vector2(6, 48), Vector2(7, 48), Vector2(8, 48),
				Vector2(4, 47), Vector2(5, 47), Vector2(6, 47), Vector2(7, 47), Vector2(8, 47)]
				
var start_zone = [Vector2i(7, 58), Vector2i(8, 58), Vector2i(9, 58), Vector2i(10, 58)]

#This is the signal we use to transfer the current grid to child nodes
signal current_grid(current_grid)

#These are the different kind of object we can have in grid cells
enum ENTITY_TYPES {GROUND, WATER, ANIMAL, FORBIDDEN, ALLOWED, CONDITIONAL, AIR}

func _ready():
	#We save the previous states of the grid in an array, this array is initalized here
	for i in range(save_states):
		last_states.append([[]])
	#Here we iterated over the grid and fill it
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			#We check each tile in your tilemap (which is the same size as the grid)
			var square = Vector2i(x, y)
			#If that tile is one of the ones we use for ground
			var tile_id = get_cell_source_id(0, square)
			#Which has ID 5
			if(tile_id == 11):
				#We check what tile it is and add it as either GROUND or WATER to the grid
				var atlas_field = get_cell_atlas_coords(0, square)
				if(atlas_field in ground):
					grid[x].append(ENTITY_TYPES.GROUND)
				elif(atlas_field in water):
					grid[x].append(ENTITY_TYPES.WATER)
			else:
				#Make the start tiles into allowed zones
				if(square in start_zone):
					grid[x].append(ENTITY_TYPES.ALLOWED)
				#Currently every other tile becomes AIR
				#This is subject to change
				grid[x].append(ENTITY_TYPES.AIR)
	color_grid()
	#Now we save the inital state of the grid for reset and previous state
	start_grid = grid.duplicate(true)
	last_states[0] = grid.duplicate(true)
	
func color_grid():
	#This function colors the grid cells that are not predefined, i.e. the background
	#We iterate over all the cells
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var square = grid[x][y]
			#An fill them with the correct tile
			#We ignore animals. Animals can have many different tiles and are handeled seperate
			if (square == ENTITY_TYPES.AIR):
				match square:
					ENTITY_TYPES.AIR:
						set_cell(0, Vector2i(x, y), 0, Vector2i(-1, -1))
					_:
						set_cell(0, Vector2i(x, y), 0, Vector2i(-1, -1))

func update_grid(pos, data):
	#If we drag an animal onto a cell we update the grid here
	var animal = data["animal"]
	var x = pos.x
	var y = pos.y
	#Based on the animal we use the apprioate filling
	match animal:
		"DEER":
			#The Deer has empty cells in its tiles, they need to be excempt
			var empty = [Vector2i(0, 3), Vector2i(3, 0), Vector2i(3, 1), Vector2i(3, 2)]
			#Similarly we need to define what new tiles are now ALLOWED for dragging
			var new_allowed = [Vector2i(0, 3), Vector2i(1, 4), Vector2i(2, 4), Vector2i(3, 4)]
			#These two loops just iterate over the grid cells we want to fill
			#Same for CONDITIONAL tiles
			var new_conditional = [Vector2i(4, 3), Vector2i(3, 0), Vector2i(3, 1), Vector2i(3, 2),
			Vector2i(-1, 0), Vector2i(-1, 1)]
			for delta in range(4):
				for epsilon in range(4):
					var tile_pos = Vector2i(delta, epsilon) 
					if(tile_pos not in empty):
						grid[x + delta][y - epsilon] = ENTITY_TYPES.ANIMAL
						set_cell(0, Vector2i(x + delta, y - epsilon), 10, Vector2i(delta, 3 - epsilon))
			for position in new_allowed:
				if(grid[x + position.x][y - position.y] == ENTITY_TYPES.AIR):
					grid[x + position.x][y - position.y] = ENTITY_TYPES.ALLOWED	
			for position in new_conditional:
				if(grid[x + position.x][y - position.y] == ENTITY_TYPES.AIR):
					grid[x + position.x][y - position.y] = ENTITY_TYPES.CONDITIONAL
		"SNAKE":
			#Snake works just like Deer
			var new_allowed = [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
			#Except we have FORBIDDEN tiles, which we also have to mark in the grid
			var new_forbidden = [Vector2i(4, 1), Vector2i(5, 1), Vector2i(5, 0), Vector2i(5, -1), Vector2i(4, -1)]
			#Same for CONDITIONAL tiles
			var new_conditional = [Vector2i(0, -1), Vector2i(1, -1), Vector2i(2, -1), Vector2i(3, -1)]
			for delta in range(5):
				grid[x + delta][y] = ENTITY_TYPES.ANIMAL
				set_cell(0, Vector2i(x + delta, y), 8, Vector2i(delta, 0))
			for position in new_allowed:
				if(grid[x + position.x][y - position.y] == ENTITY_TYPES.AIR):
					grid[x + position.x][y - position.y] = ENTITY_TYPES.ALLOWED
			for position in new_forbidden:
				if(grid[x + position.x][y - position.y] == ENTITY_TYPES.AIR):
					grid[x + position.x][y - position.y] = ENTITY_TYPES.FORBIDDEN
			for position in new_conditional:
				if(grid[x + position.x][y - position.y] == ENTITY_TYPES.AIR):
					grid[x + position.x][y - position.y] = ENTITY_TYPES.CONDITIONAL
		"SPIDER":
			#Spider is the easiest, nothing much happens here
			var new_allowed = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, -1)]
			grid[x][y] = ENTITY_TYPES.ANIMAL
			set_cell(0, Vector2i(x, y), 9, Vector2i(0, 0))
			for position in new_allowed:
				if(grid[x + position.x][y - position.y] == ENTITY_TYPES.AIR):
					grid[x + position.x][y - position.y] = ENTITY_TYPES.ALLOWED
	#Whenever we change the grid, i.e. update it, we have to track that here
	state += 1
	#This allows us to track the previous states and return to them
	last_states[state % save_states] = grid.duplicate(true)

func make_visible():
	#We do not color the FORBIDDEN or ALLOWED cells on ready
	#Instead we only color them we are dragging, this function does that
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if(grid[x][y] == ENTITY_TYPES.FORBIDDEN):
				set_cell(0, Vector2i(x, y), 7, Vector2i(1, 1))
			elif(grid[x][y] == ENTITY_TYPES.ALLOWED):
				set_cell(0, Vector2i(x, y), 6, Vector2i(1, 1))
			elif(grid[x][y] == ENTITY_TYPES.CONDITIONAL):
				set_cell(0, Vector2i(x, y), 4, Vector2i(1, 1))

func make_invisible():
	#Similarly when we are done dragging we want to return the FORBIDDEN and ALLOWED cells invisible
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if(grid[x][y] == ENTITY_TYPES.FORBIDDEN or grid[x][y] == ENTITY_TYPES.ALLOWED
			or grid[x][y] == ENTITY_TYPES.CONDITIONAL):
				set_cell(0, Vector2i(x, y), 0, Vector2i(-1, -1))

func reset_grid():
	#To reset the grid we simple return it to the state we saved in the begining
	grid = start_grid.duplicate(true)
	#Then we recolor it
	color_grid()
	#And clean the save-states
	last_states = []
	for i in range(save_states):
		last_states.append([[]])
	state = 0

func last_state():
	#To return to the previous state of the grid we have to make sure that such a state exists
	#Here we check if somebody tried to reset the start, this is not allowed
	if(state == 0):
		reset_grid()
	else:
		#Similarly the previous state might be empty for various rare reasons
		#We catch that here, but it is not very necessary
		if(last_states[state % save_states] == [[]]):
			reset_grid()
		else:
			#Lastly we check if the previous state exists
			state -= 1
			if(last_states[state % save_states] == [[]]):
				state += 1
				return
			#If it does we return the grid to it and recolor it
			grid = last_states[state % save_states].duplicate(true)
			last_states[(state + 1) % save_states] = [[]]
			color_grid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#Down here we handle all the signal. There will be many, but most of them don't do much.
func _on_drag_grid_need_grid():
	current_grid.emit(grid)

func _on_deer_item_need_grid():
	current_grid.emit(grid)

func _on_snake_item_need_grid():
	current_grid.emit(grid)

func _on_spider_item_need_grid():
	current_grid.emit(grid)

func _on_drag_grid_update_grid(pos, data):
	update_grid(pos, data)

func _on_deer_item_update_grid(pos, data):
	update_grid(pos, data)

func _on_snake_item_update_grid(pos, data):
	update_grid(pos, data)

func _on_spider_item_update_grid(pos, data):
	update_grid(pos, data)

func _on_drag_grid_dragging_done():
	make_invisible()

func _on_drag_grid_is_dragging():
	make_visible()

func _on_deer_item_dragging_done():
	make_invisible()

func _on_deer_item_is_dragging():
	make_visible()

func _on_snake_item_dragging_done():
	make_invisible()

func _on_snake_item_is_dragging():
	make_visible()

func _on_spider_item_dragging_done():
	make_invisible()

func _on_spider_item_is_dragging():
	make_visible()

func _on_reset_pressed():
	reset_grid()

func _on_last_state_pressed():
	last_state()
