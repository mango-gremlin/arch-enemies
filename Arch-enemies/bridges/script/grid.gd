extends TileMap

var tile_size = tile_set.tile_size

var x_size = 115
var y_size = 65

var grid_size = Vector2(x_size, y_size)
var grid = []
var start_grid = [[[]]]
var last_states = []
var save_states = 10
var state = 0

var start_zone = [Vector2(11, 50), Vector2(12, 50), Vector2(13, 50), Vector2(14, 50)]
var fox_start = [Vector2(4, 50), Vector2(5, 50), Vector2(6, 50), Vector2(7, 50), Vector2(8, 50),
				Vector2(4, 49), Vector2(5, 49), Vector2(6, 49), Vector2(7, 49), Vector2(8, 49), 
				Vector2(4, 48), Vector2(5, 48), Vector2(6, 48), Vector2(7, 48), Vector2(8, 48),
				Vector2(4, 47), Vector2(5, 47), Vector2(6, 47), Vector2(7, 47), Vector2(8, 47)]

signal current_grid(current_grid)

enum ENTITY_TYPES {GROUND, WATER, ANIMAL, FORBIDDEN, ALLOWED, AIR}

func _ready():
	for i in range(save_states):
		last_states.append([[]])
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
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
	color_grid()
	start_grid = grid.duplicate(true)
	last_states[0] = grid.duplicate(true)
	
func color_grid():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var square = grid[x][y]
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
	var animal = data["animal"]
	var x = pos.x
	var y = pos.y
	match animal:
		"DEER":
			var empty = [Vector2i(0, 3), Vector2i(3, 0), Vector2i(3, 1), Vector2i(3, 2)]
			var new_allowed = [Vector2i(0, 3), Vector2i(1, 4), Vector2i(2, 4), Vector2i(3, 4)]
			for delta in range(4):
				for epsilon in range(4):
					var tile_pos = Vector2i(delta, epsilon) 
					if(tile_pos not in empty):
						grid[x + delta][y - epsilon] = ENTITY_TYPES.ANIMAL
						set_cell(0, Vector2i(x + delta, y - epsilon), 10, Vector2i(delta, 3 - epsilon))
			for position in new_allowed:
				if(grid[x + position.x][y - position.y] == ENTITY_TYPES.AIR):
					grid[x + position.x][y - position.y] = ENTITY_TYPES.ALLOWED					
		"SNAKE":
			var new_allowed = [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
			var new_forbidden = [Vector2i(4, 1), Vector2i(5, 1), Vector2i(5, 0), Vector2i(5, -1), Vector2i(4, -1)]
			for delta in range(5):
				grid[x + delta][y] = ENTITY_TYPES.ANIMAL
				set_cell(0, Vector2i(x + delta, y), 8, Vector2i(delta, 0))
			for position in new_allowed:
				if(grid[x + position.x][y - position.y] == ENTITY_TYPES.AIR):
					grid[x + position.x][y - position.y] = ENTITY_TYPES.ALLOWED
			for position in new_forbidden:
				if(grid[x + position.x][y - position.y] == ENTITY_TYPES.AIR):
					grid[x + position.x][y - position.y] = ENTITY_TYPES.FORBIDDEN
		"SPIDER":
			var new_allowed = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, -1)]
			grid[x][y] = ENTITY_TYPES.ANIMAL
			set_cell(0, Vector2i(x, y), 9, Vector2i(0, 0))
			for position in new_allowed:
				if(grid[x + position.x][y - position.y] == ENTITY_TYPES.AIR):
					grid[x + position.x][y - position.y] = ENTITY_TYPES.ALLOWED
	state += 1
	last_states[state % save_states] = grid.duplicate(true)

func make_visible():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if(grid[x][y] == ENTITY_TYPES.FORBIDDEN):
				set_cell(0, Vector2i(x, y), 7, Vector2i(1, 1))
			elif(grid[x][y] == ENTITY_TYPES.ALLOWED):
				set_cell(0, Vector2i(x, y), 2, Vector2i(1, 1))

func make_invisible():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if(grid[x][y] == ENTITY_TYPES.FORBIDDEN or grid[x][y] == ENTITY_TYPES.ALLOWED):
				set_cell(0, Vector2i(x, y), 0, Vector2i(1, 1))

func reset_grid():
	grid = start_grid.duplicate(true)
	color_grid()
	last_states = []
	for i in range(save_states):
		last_states.append([[]])
	state = 0

func last_state():
	if(state == 0):
		reset_grid()
	else:
		if(last_states[state % save_states] == [[]]):
			reset_grid()
		else:
			state -= 1
			if(last_states[state % save_states] == [[]]):
				state += 1
				return
			grid = last_states[state % save_states].duplicate(true)
			last_states[(state + 1) % save_states] = [[]]
			color_grid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
