extends Node2D

@onready var grid = get_parent()

func _ready():
	pass

# if an object is being dragged, show grid
func _process(_delta):
	load("res://bridges/script/global.gd")
	if Global.something_is_being_dragged:
		visible = true
	else:
		visible = false

func _draw():
	var LINE_COLOR = Color(0, 0, 0)
	var LINE_WIDTH = 1
	var window_size = get_viewport().get_visible_rect().size

	for x in range(grid.grid_size.x + 1):
		var col_pos = x * grid.tile_size.x
		var limit = grid.grid_size.y * grid.tile_size.y
		draw_line(Vector2(col_pos, 0), Vector2(col_pos, limit), LINE_COLOR, LINE_WIDTH)
	for y in range(grid.grid_size.y + 1):
		var row_pos = y * grid.tile_size.y
		var limit = grid.grid_size.x * grid.tile_size.x
		draw_line(Vector2(0, row_pos), Vector2(limit, row_pos), LINE_COLOR, LINE_WIDTH)
