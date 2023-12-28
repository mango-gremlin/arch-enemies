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

#This defined the start-zone and conditional-zone for the bridge
var start_zone = [Vector2(11, 50), Vector2(12, 50), Vector2(13, 50), Vector2(14, 50)]

#And the start zone for the Fox
var fox_start = [Vector2(4, 50), Vector2(5, 50), Vector2(6, 50), Vector2(7, 50), Vector2(8, 50),
				Vector2(4, 49), Vector2(5, 49), Vector2(6, 49), Vector2(7, 49), Vector2(8, 49), 
				Vector2(4, 48), Vector2(5, 48), Vector2(6, 48), Vector2(7, 48), Vector2(8, 48),
				Vector2(4, 47), Vector2(5, 47), Vector2(6, 47), Vector2(7, 47), Vector2(8, 47)]

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
			#These are the specific fields we want to fill, essentially the level is defined here
			if((x < 15 or (x < x_size and x > (x_size - 15))) and y > (y_size - 15)):
				grid[x].append(ENTITY_TYPES.GROUND)
			elif(Vector2(x, y) in start_zone):
				grid[x].append(ENTITY_TYPES.ALLOWED)
			elif(Vector2(x, y) in fox_start):
				grid[x].append(ENTITY_TYPES.FORBIDDEN)
			elif(y > (y_size - 10)):
				grid[x].append(ENTITY_TYPES.WATER)
			else:
				grid[x].append(ENTITY_TYPES.AIR)
	#The previous function only filled the internal represtation of grid
	#With color Grid we fill the displayed grid with color
	color_grid()
	
	#Now we save the inital state of the grid for reset and previous state
	start_grid = grid.duplicate(true)
	last_states[0] = grid.duplicate(true)
	
func color_grid():
	#This function color the grid
	#We iterate over all the cells
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var square = grid[x][y]
			#An fill them with the correct tile
			#We ignore animals. Animals can have many different tiles and are handeled seperate
			if (square != ENTITY_TYPES.ANIMAL):
				match square:
					ENTITY_TYPES.GROUND:
						set_cell(0, Vector2i(x, y), 1, Vector2i(1, 1))
					ENTITY_TYPES.WATER:
						set_cell(0, Vector2i(x, y), 3, Vector2i(1, 1))
					ENTITY_TYPES.AIR:
						set_cell(0, Vector2i(x, y), 0, Vector2i(1, 1))
					_:
						set_cell(0, Vector2i(x, y), 0, Vector2i(1, 1))

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
				set_cell(0, Vector2i(x, y), 2, Vector2i(1, 1))
			elif(grid[x][y] == ENTITY_TYPES.CONDITIONAL):
				set_cell(0, Vector2i(x, y), 4, Vector2i(1, 1))

func make_invisible():
	#Similarly when we are done dragging we want to return the FORBIDDEN and ALLOWED cells invisible
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if(grid[x][y] == ENTITY_TYPES.FORBIDDEN or grid[x][y] == ENTITY_TYPES.ALLOWED
			or grid[x][y] == ENTITY_TYPES.CONDITIONAL):
				set_cell(0, Vector2i(x, y), 0, Vector2i(1, 1))

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
