extends TileMap

#We define the basic variables here

# 
var menu_mode := false
var goal_reached := false

#Like the Tile Size
var tile_size = tile_set.tile_size

#The Dimensions of the Grid
#We add some variables to adjust to the zoom
#Base asumption is no zoom, but it essentially does not matter for our purposes
var x_zoom = 1
var y_zoom = 1
@export var x_size = int(DisplayServer.window_get_size().x / int(10 * x_zoom)) + 1
@export var y_size = int(DisplayServer.window_get_size().y / int(10 * y_zoom)) + 1
@export var square_size = 10

@export var inventory_deer : Label
@export var inventory_snake : Label
@export var inventory_spider : Label
@export var inventory_squirrel : Label

#And finally some values we need later
var grid_size = Vector2(x_size, y_size)
var grid = []
var start_grid = [[[]]]
var last_states = []
var save_states = 10
var state = 0

#for the inventory
@onready var start_animals : Dictionary = SingletonPlayer.get_animal_inventory().duplicate(true)
#var start_animals : Dictionary = set_animal_inventory()	
var placed_animals: Array = []


# ids of all tilemap layers
const BACKGROUND_LAYER_ID = 0
const ACTIVE_LAYER_ID = 1

# ids of our tilesets for their respective types
const AIR_TILE_ID = 1
const GROUND_TILE_ID = 2
const WATER_TILE_ID = 3
const BRAMBLE_TILE_ID = 6

const SQUIRREL_TILE_ID = 5 
const SNAKE_TILE_ID = 8
const SPIDER_TILE_ID = 9
const DEER_TILE_ID = 10

const GREEN_TILE_ID = 0
const YELLOW_TILE_ID = 4
const RED_TILE_ID = 7

# list of starting dropzones of their respective type
var shore_top = []
var shore_side = []
var shore_bottom = []
var shallow_squares = []
var hazard_squares = []
var water_squares = []

#This is the signal we use to transfer the current grid to child nodes
signal current_grid(current_grid)
signal get_zoom()
signal play_sound(sound)

#These are the different kind of object we can have in grid cells
enum ENTITY_TYPES {GROUND, WATER, AIR, ANIMAL, FORBIDDEN, ALLOWED, SIDE, BOTTOM, SHALLOW}

func _ready():
	#update the ui
	update_inventory()
	
	# reset walking
	Global.walking = false
	
	# reset the menu_mode,drag_mode and goal_reached
	reset_modes()
	
	#We save the previous states of the grid in an array, this array is initalized here
	for i in range(save_states):
		last_states.append([[]])
	#We have to adjust the window size if zoomed in
	get_zoom.emit()
	#Here we iterated over the grid and fill it
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			#We check each tile in your tilemap (which is the same size as the grid)
			var square = Vector2i(x, y)
			# get id of the tile of the current square
			var tile_id = get_cell_source_id(BACKGROUND_LAYER_ID, square)
			# if that tileset is ground, assing it to that type, and check for startzones
			if(tile_id == GROUND_TILE_ID):
				grid[x].append(ENTITY_TYPES.GROUND)
				
				# check if the tile above is in ground or water
				var top_square = Vector2i(x, y - 1)
				if is_shore_dropzone(top_square):
					shore_top.append(top_square)
				
				# check if the tile below is in ground or water
				var bottom_square = Vector2i(x, y + 1)
				if is_shore_dropzone(bottom_square):
					shore_bottom.append(bottom_square)
				
				# check if the tile to the left is in ground or water
				var left_square = Vector2i(x - 1, y)
				if is_shore_dropzone(left_square):
					shore_side.append(left_square)
				
				# check if the tile to the right is in ground or water
				var right_square = Vector2i(x + 1, y)
				if is_shore_dropzone(right_square):
					shore_side.append(right_square)
			
			# if that tileset is water, assign to that type
			elif(tile_id == WATER_TILE_ID):
				grid[x].append(ENTITY_TYPES.WATER)
				water_squares.append(square)
				
				# check if square is a shallow
				# a shallow has air or decoration above, and ground below
				var top_square = Vector2i(x, y - 1)
				var top_square_tile_id = get_cell_source_id(BACKGROUND_LAYER_ID, top_square)
				var bottom_square = Vector2i(x, y + 1)
				var bottom_square_tile_id = get_cell_source_id(BACKGROUND_LAYER_ID, bottom_square)
				if ((top_square_tile_id == AIR_TILE_ID or top_square_tile_id == -1)
					and bottom_square_tile_id == GROUND_TILE_ID):
					shallow_squares.append(square) 
				
			elif(tile_id == BRAMBLE_TILE_ID):
				grid[x].append(ENTITY_TYPES.FORBIDDEN)
				hazard_squares.append(square)
			
			# if that tileset is air, assign to that type
			else:
				#Currently every other tile becomes AIR
				grid[x].append(ENTITY_TYPES.AIR)
	
	# assign shore dropzones
	grid = assign_dropzones(grid, shore_bottom, ENTITY_TYPES.BOTTOM)
	grid = assign_dropzones(grid, shore_side, ENTITY_TYPES.SIDE)
	grid = assign_dropzones(grid, shallow_squares, ENTITY_TYPES.SHALLOW)
	grid = assign_dropzones(grid, shore_top, ENTITY_TYPES.ALLOWED)
	
	# assign hazard forbidden zone
	# is handled separately here, so it doesn't get overwritten earlier
	grid = assign_dropzones(grid, hazard_squares, ENTITY_TYPES.FORBIDDEN)
	
	# assign forbidden zones around the fox' starting position
	grid = assign_fox_forbidden_zones(grid)
	
	var danger_area = preload("res://bridges/scenes/danger_detection.tscn")
	var danger_squares = water_squares + hazard_squares
	spawn_danger_area2D(danger_area, danger_squares)
	
	color_grid()
	#Now we save the inital state of the grid for reset and previous state
	start_grid = grid.duplicate(true)
	last_states[0] = grid.duplicate(true)

# iterates through list and assignes all squares to desired type
func assign_dropzones(grid:Array, squares:Array, type:ENTITY_TYPES) -> Array:
	for square in squares:
		grid[square.x][square.y] = type
	return grid

# checks if square isn't in ground or water, and is within grid bounds
func is_shore_dropzone(square:Vector2i) -> bool:
	var tile_id = get_cell_source_id(BACKGROUND_LAYER_ID, square)
	if (tile_id != GROUND_TILE_ID
		and tile_id != WATER_TILE_ID
		and square.x >= 0 and square.y >= 0
		and square.x < grid_size.x and square.y < grid_size.y):
		return true
	return false

# takes grid as input, assigns forbidden zones around the fox sprite
func assign_fox_forbidden_zones(grid:Array) -> Array:
	# get position of fox
	var fox_global_position = $Player.global_position
	
	# round to nearest grid square
	var fox_grid_x = Global.round_to_nearest(fox_global_position.x, square_size) / square_size
	var fox_grid_y = Global.round_to_nearest(fox_global_position.y, square_size) / square_size
	var fox_grid_position = Vector2i(fox_grid_x, fox_grid_y)
	
	# iterate over 4x3 squares with (1,2) being fox centre
	for x_offset in range(-2,2):
		for y_offset in range(-1,2):
			var crt_square = Vector2i(fox_grid_position.x + x_offset, fox_grid_position.y + y_offset)
			# assign each square as forbidden
			grid[crt_square.x][crt_square.y] = ENTITY_TYPES.FORBIDDEN
	return grid

# instantiate area2D with their respective collision shapes
# as they are dangers, add a signal that is emitted when fox touches them
func spawn_danger_area2D(area, squares):
	for square in squares:
		var instance = area.instantiate()
		self.add_child(instance)
		instance.global_position = Vector2(square.x * 10 + 5, square.y * 10 + 5)
		instance.body_entered.connect(on_contact_danger)

# when contacting a danger, reset the position of fox
func on_contact_danger(body):
	if not Global.drag_mode:
		play_sound.emit("DEATH")
		$Player.reset_player()

func color_grid():
	#This function colors the grid cells that are not predefined, i.e. the background
	#We iterate over all the cells
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var square = grid[x][y]
			#An fill them with the correct tile
			#We ignore animals. Animals can have many different tiles and are handeled seperate
			if (square != ENTITY_TYPES.GROUND and square != ENTITY_TYPES.WATER and 
			square != ENTITY_TYPES.ANIMAL):
				match square:
					ENTITY_TYPES.AIR:
						#Note that this effectively just makes them transparent
						set_cell(ACTIVE_LAYER_ID, Vector2i(x, y), 0, Vector2i(-1, -1))
					_:
						set_cell(ACTIVE_LAYER_ID, Vector2i(x, y), 0, Vector2i(-1, -1))

func update_grid(pos, data):
	#If we drag an animal onto a cell we update the grid here
	var animal = data["animal"]
	var x = pos.x
	var y = pos.y
	
	#Whenever we change the grid, i.e. update it, we have to track that here
	state += 1
	
	#Based on the animal we use the apprioate filling
	match animal:
		"DEER":
			#The Deer has empty cells in its tiles, they need to be excempt
			var empty = [Vector2i(0, 3), Vector2i(3, 0), Vector2i(3, 1), Vector2i(3, 2)]
			#Similarly we need to define what new tiles are now ALLOWED for dragging
			var new_allowed = [Vector2i(0, 3), Vector2i(1, 4), Vector2i(2, 4), Vector2i(3, 4)]
			#Same for SIDE tiles
			var new_side = [Vector2i(4, 3), Vector2i(3, 0), Vector2i(3, 1), Vector2i(3, 2),
			Vector2i(-1, 0), Vector2i(-1, 1)]
			#Same for BOTTOM tiles
			var new_bottom = [Vector2i(0, -1), Vector2i(1, -1), Vector2i(2, -1)]
			# middle offset
			x -= 1
			y += 1
			#These two loops just iterate over the grid cells we want to fill
			for delta in range(4):
				for epsilon in range(4):
					var tile_pos = Vector2i(delta, epsilon) 
					if(tile_pos not in empty):
						grid[x + delta][y - epsilon] = ENTITY_TYPES.ANIMAL
						set_cell(ACTIVE_LAYER_ID, Vector2i(x + delta, y - epsilon), DEER_TILE_ID, Vector2i(delta, 3 - epsilon))
			for position in new_allowed:
				var current = grid[x + position.x][y - position.y]
				tile_update(Vector2i(x + position.x, y - position.y), current, ENTITY_TYPES.ALLOWED)
			for position in new_side:
				var current = grid[x + position.x][y - position.y]
				tile_update(Vector2i(x + position.x, y - position.y), current, ENTITY_TYPES.SIDE)
			for position in new_bottom:
				var current = grid[x + position.x][y - position.y]
				tile_update(Vector2i(x + position.x, y - position.y), current, ENTITY_TYPES.BOTTOM)

			placed_animals.append(Animal.AnimalType.DEER)
			add_to_animal_inventory(Animal.AnimalType.DEER,-1)
		"SNAKE":
			#Snake works just like Deer
			var new_allowed = [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
			#Except we have FORBIDDEN tiles, which we also have to mark in the grid
			var new_forbidden = [Vector2i(4, 1), Vector2i(5, 1), Vector2i(5, 0), Vector2i(5, -1), Vector2i(4, -1)]
			#Same for SIDE tiles
			var new_side = [Vector2i(-1, 0)]
			#Same for BOTTOM tiles
			var new_bottom = [Vector2i(0, -1), Vector2i(1, -1), Vector2i(2, -1), Vector2i(3, -1)]
			x -= 2 # middle offset
			for delta in range(5):
				grid[x + delta][y] = ENTITY_TYPES.ANIMAL
				set_cell(ACTIVE_LAYER_ID, Vector2i(x + delta, y), SNAKE_TILE_ID, Vector2i(delta, 0))
			for position in new_allowed:
				var current = grid[x + position.x][y - position.y]
				tile_update(Vector2i(x + position.x, y - position.y), current, ENTITY_TYPES.ALLOWED)
			for position in new_forbidden:
				var current = grid[x + position.x][y - position.y]
				tile_update(Vector2i(x + position.x, y - position.y), current, ENTITY_TYPES.FORBIDDEN)
			for position in new_side:
				var current = grid[x + position.x][y - position.y]
				tile_update(Vector2i(x + position.x, y - position.y), current, ENTITY_TYPES.SIDE)
			for position in new_bottom:
				var current = grid[x + position.x][y - position.y]
				tile_update(Vector2i(x + position.x, y - position.y), current, ENTITY_TYPES.BOTTOM)

			placed_animals.append(Animal.AnimalType.SNAKE)
			add_to_animal_inventory(Animal.AnimalType.SNAKE,-1)
		"SPIDER":
			#Spider is the easiest, nothing much happens here
			var new_allowed = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]
			grid[x][y] = ENTITY_TYPES.ANIMAL
			set_cell(ACTIVE_LAYER_ID, Vector2i(x, y), SPIDER_TILE_ID, Vector2i(0, 0))
			for position in new_allowed:
				var current = grid[x + position.x][y - position.y]
				tile_update(Vector2i(x + position.x, y - position.y), current, ENTITY_TYPES.ALLOWED)

			placed_animals.append(Animal.AnimalType.SPIDER)
			add_to_animal_inventory(Animal.AnimalType.SPIDER,-1)
		"SQUIRREL":
			#Squirrel like the other animals
			var new_allowed = [Vector2i(0, 2)]
			var new_side = [Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(1, 0), Vector2i(1, 1)]
			var new_bottom = [Vector2i(0, -1)]
			for epsilon in range(2):
				grid[x][y - epsilon] = ENTITY_TYPES.ANIMAL
				set_cell(ACTIVE_LAYER_ID, Vector2i(x, y - epsilon), SQUIRREL_TILE_ID, Vector2i(0, 1 - epsilon))
			for position in new_allowed:
				var current = grid[x + position.x][y - position.y]
				tile_update(Vector2i(x + position.x, y - position.y), current, ENTITY_TYPES.ALLOWED)
			for position in new_side:
				var current = grid[x + position.x][y - position.y]
				tile_update(Vector2i(x + position.x, y - position.y), current, ENTITY_TYPES.SIDE)
			for position in new_bottom:
				var current = grid[x + position.x][y - position.y]
				tile_update(Vector2i(x + position.x, y - position.y), current, ENTITY_TYPES.BOTTOM)
			
			placed_animals.append(Animal.AnimalType.SQUIRREL)
			add_to_animal_inventory(Animal.AnimalType.SQUIRREL,-1)
			
	#This allows us to track the previous states and return to them
	last_states[state % save_states] = grid.duplicate(true)
	
	#update the global inventory
	update_inventory()

func make_visible():
	#We do not color the FORBIDDEN or ALLOWED cells on ready
	#Instead we only color them when we are dragging, this function does that
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if grid[x][y] == ENTITY_TYPES.FORBIDDEN:
				set_cell(ACTIVE_LAYER_ID, Vector2i(x, y), RED_TILE_ID, Vector2i(1, 1))
			elif grid[x][y] == ENTITY_TYPES.ALLOWED:
				set_cell(ACTIVE_LAYER_ID, Vector2i(x, y), GREEN_TILE_ID, Vector2i(1, 1))
			elif grid[x][y] == ENTITY_TYPES.SIDE:
				set_cell(ACTIVE_LAYER_ID, Vector2i(x, y), YELLOW_TILE_ID, Vector2i(1, 1))
			elif grid[x][y] == ENTITY_TYPES.BOTTOM:
				set_cell(ACTIVE_LAYER_ID, Vector2i(x, y), YELLOW_TILE_ID, Vector2i(1, 1))
			elif grid[x][y] == ENTITY_TYPES.SHALLOW:
				set_cell(ACTIVE_LAYER_ID, Vector2i(x, y), YELLOW_TILE_ID, Vector2i(1, 1))
	Global.something_is_being_dragged = true

func make_invisible():
	#Similarly when we are done dragging we want to return the FORBIDDEN and ALLOWED cells invisible
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if(grid[x][y] == ENTITY_TYPES.FORBIDDEN 
				or grid[x][y] == ENTITY_TYPES.ALLOWED
				or grid[x][y] == ENTITY_TYPES.SIDE 
				or grid[x][y] == ENTITY_TYPES.BOTTOM
				or grid[x][y] == ENTITY_TYPES.SHALLOW):
				set_cell(ACTIVE_LAYER_ID, Vector2i(x, y), 0, Vector2i(-1, -1))
	Global.something_is_being_dragged = false

func reset_grid():
	#To reset the grid we simple return it to the state we saved in the beginning
	if Global.drag_mode:
		#reset the inventory to the original amount of animals
		start_animals = SingletonPlayer.get_animal_inventory().duplicate(true)
		update_inventory()
		
		grid = start_grid.duplicate(true)
		#Then we recolor it
		color_grid()
		#And clean the save-states
		last_states = []
		for i in range(save_states):
			last_states.append([[]])
			
		placed_animals = []
		state = 0

func last_state():
	#To return to the previous state of the grid we have to make sure that such a state exists
	#Here we check if somebody tried to reset the start, this is not allowed
	if Global.drag_mode:
		if(state == 0):
			reset_grid()
		else:
			#Lastly we check if the previous state exists
			state -= 1
			if(last_states[state % save_states] == [[]]):
				if(state > 0):
					state += 1
					return
				else:
					reset_grid()
					return
			#If it does we return the grid to it and recolor it
			grid = last_states[state % save_states].duplicate(true)
			last_states[(state + 1) % save_states] = [[]]
			color_grid()
			
			var last_animal = placed_animals.pop_back()
			start_animals[last_animal] += 1
			
			update_inventory()


func tile_update(pos, current, next):
	#We check what the current square is, based on what we want to put there next we either do it
	#Or do not do it. Hierarch is currently FORBIDDEN > SHALLOW > ALLOWED > SIDE > BOTTOM > AIR
	if current == ENTITY_TYPES.AIR:
		grid[pos.x][pos.y] = next
	elif current == ENTITY_TYPES.SHALLOW and next == ENTITY_TYPES.FORBIDDEN:
		grid[pos.x][pos.y] = next
	elif current == ENTITY_TYPES.BOTTOM and not next == ENTITY_TYPES.SHALLOW:
		grid[pos.x][pos.y] = next
	elif current == ENTITY_TYPES.SIDE and not next == ENTITY_TYPES.SHALLOW and not next == ENTITY_TYPES.BOTTOM:
		grid[pos.x][pos.y] = next
	elif current == ENTITY_TYPES.ALLOWED and next == ENTITY_TYPES.FORBIDDEN:
		grid[pos.x][pos.y] = next

# change the visibility of all ui elements in bridge scene
func change_ui_visibility():
	find_child("Drag_or_Fox").visible = not find_child("Drag_or_Fox").visible
	find_child("Reset").visible = not find_child("Reset").visible
	find_child("Last_State").visible = not find_child("Last_State").visible
	find_child("Animal_Inventory").visible = not find_child("Animal_Inventory").visible
	find_child("animal_inventory_counter").visible = not find_child("animal_inventory_counter").visible
	find_child("Player").visible = not find_child("Player").visible

# reset menu,drag and goal variables
func reset_modes():
	var mode_button = find_child("Drag_or_Fox")
	mode_button.button_pressed = false
	mode_button.text = "Drag Mode"
	Global.drag_mode = true
	menu_mode = false
	goal_reached = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Global.currently_dragging and Input.is_action_just_released("click")):
		make_invisible()
		
	# pressing "esc" opens the pause-menu
	if Input.is_action_just_pressed("open_menu") and not goal_reached:
		open_pause_menu()
		

func open_pause_menu():
	Global.walking = false
	var pause_menu = get_parent().find_child("bridges_pause_menu")
	var new_visibility = not pause_menu.visible
	pause_menu.visible = new_visibility
	# menu_mode is active when pause_menu is visible
	menu_mode = new_visibility
	change_ui_visibility()

	
# --- / 
# -- / inventory management

# updates animal amount with given value ( could either be pos / neg )
func add_to_animal_inventory(animal:Animal.AnimalType, additional_value:int):
	start_animals[animal] = start_animals[animal] + additional_value

# takes Dictionary containing the used animals. 
# will add those animals ( their int representation) back to the local animal inventory
# restoring the initial state
func restore_animal_from_placed_animals(placed_animals:Dictionary):
	for animal in placed_animals:
		# adding the "removed" amount of animals back to the original position
		start_animals[animal] += 1

# takes local inventory, duplicates it and replace 
# singleton animal_inventory with it
func set_global_animal_inventory(animal_inventory:Dictionary):
	SingletonPlayer.set_animal_inventory(animal_inventory.duplicate(true))

#updates the ui-counters for the inventory
func update_inventory():
	inventory_deer.text = str(start_animals[Animal.AnimalType.DEER])
	inventory_snake.text = str(start_animals[Animal.AnimalType.SNAKE])
	inventory_spider.text = str(start_animals[Animal.AnimalType.SPIDER])
	inventory_squirrel.text = str(start_animals[Animal.AnimalType.SQUIRREL])

#Down here we handle all the signal. There will be many, but most of them don't do much.
func _on_drag_grid_need_grid():
	current_grid.emit(grid)

func _on_deer_item_need_grid():
	current_grid.emit(grid)

func _on_snake_item_need_grid():
	current_grid.emit(grid)

func _on_spider_item_need_grid():
	current_grid.emit(grid)

func _on_squirrel_item_need_grid():
	current_grid.emit(grid)

func _on_drag_grid_update_grid(pos, data):
	update_grid(pos, data)

func _on_deer_item_update_grid(pos, data):
	update_grid(pos, data)

func _on_snake_item_update_grid(pos, data):
	update_grid(pos, data)

func _on_spider_item_update_grid(pos, data):
	update_grid(pos, data)

func _on_squirrel_item_update_grid(pos, data):
	update_grid(pos, data)

func _on_drag_grid_is_dragging():
	make_visible()

func _on_deer_item_is_dragging():
	make_visible()

func _on_snake_item_is_dragging():
	make_visible()

func _on_spider_item_is_dragging():
	make_visible()

func _on_squirrel_item_is_dragging():
	make_visible()

func _on_reset_pressed():
	reset_grid()

func _on_last_state_pressed():
	last_state()

func _on_camera_2d_send_zoom(zoom):
	#We adjust and recalculate the zoom if necessary
	x_zoom = zoom.x
	y_zoom = zoom.y
	x_size = int(DisplayServer.window_get_size().x / int(10 * x_zoom)) + 1
	y_size = int(DisplayServer.window_get_size().y / int(10 * y_zoom)) + 1
	grid_size = Vector2(x_size, y_size)


func _on_goal_menu_level_solved():
	play_sound.emit("VICTORY")
	print("updating inventory of overworld")
	set_global_animal_inventory(start_animals)


func _on_tutorial_button_pressed():
	get_parent().get_node("Tutorial").visible = true
	self.visible = false
