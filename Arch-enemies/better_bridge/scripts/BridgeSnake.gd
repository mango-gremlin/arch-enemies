extends BrigdeAnimal

class_name BridgeSnake

func _init():
	source_id = 1
	atlas_pos = Vector2i.ZERO
	body_cells = [Vector2i(0,0), Vector2i(-1,0), Vector2i(-2,0), Vector2i(1,0), Vector2i(2,0)]
	attach_cells = []

func is_valid_tile_type(tile_type : BridgeBuilder.TILE_TYPE):
	return true
