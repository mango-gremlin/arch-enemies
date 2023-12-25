extends TextureRect

var grid = []
enum ENTITY_TYPES {GROUND, WATER, ANIMAL, FORBIDDEN, ALLOWED, AIR}
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
	need_grid.emit()
	is_dragging.emit()
	
	var data = {}
	var preview = TextureRect.new()
	var sprite = texture
	var animal = tooltip_text 
	
	if(sprite != null):
		preview.expand = true
		preview.texture = sprite
		match animal:
			"DEER":
				preview.set_size(Vector2(40, 40))
			"SNAKE":
				preview.set_size(Vector2(50, 10))
			"SPIDER":
				preview.set_size(Vector2(10, 10))
	
	data["sprite"] = sprite
	data["animal"] = animal
	
	set_drag_preview(preview)
	
	return data

func _can_drop_data(at_position, data):
	var position = get_global_mouse_position()
	var y = int(position.y/10)
	var x = int(position.x/10)
	var pos = Vector2i(x, y)
	var is_allowed = false
	var animal = data["animal"]
	
	match animal:
		"DEER":
			is_allowed = is_deer_allowed(pos)
		"SNAKE":
			is_allowed = is_snake_allowed(pos)
		"SPIDER":
			is_allowed = is_spider_allowed(pos)

	return is_allowed

func _drop_data(at_position, data):
	var position = Vector2(int(get_global_mouse_position().x / 10), 
	int(get_global_mouse_position().y / 10))
	dragging_done.emit()
	update_grid.emit(position, data)

func _on_grid_current_grid(current_grid):
	grid = current_grid

func is_snake_allowed(pos):
	var is_allowed = false
	if(grid[pos.x][pos.y] == ENTITY_TYPES.ALLOWED):
		var is_free = true
		for delta in range(1, 5):
			if(not (grid[pos.x + delta][pos.y] == ENTITY_TYPES.AIR or 
			grid[pos.x + delta][pos.y] == ENTITY_TYPES.ALLOWED)):
				is_free = false
				break
		if(is_free):
			is_allowed = true
	return is_allowed

func is_spider_allowed(pos):
	var is_allowed = false
	if(grid[pos.x][pos.y] == ENTITY_TYPES.ALLOWED):
		is_allowed = true
	return is_allowed

func is_deer_allowed(pos):
	var is_allowed = false
	var allowed = [Vector2i(0, 3), Vector2i(3, 0), Vector2i(3, 1), Vector2i(3, 2)]
	if(grid[pos.x][pos.y] == ENTITY_TYPES.ALLOWED):
		var is_free = true
		for delta in range(4):
			for epsilon in range(4):
				if(not (grid[pos.x + delta][pos.y - epsilon] == ENTITY_TYPES.AIR or 
				grid[pos.x + delta][pos.y - epsilon] == ENTITY_TYPES.ALLOWED)):
					if(Vector2i(delta, epsilon) not in allowed):
						is_free = false
						break
		if(is_free):
			is_allowed = true
	return is_allowed
