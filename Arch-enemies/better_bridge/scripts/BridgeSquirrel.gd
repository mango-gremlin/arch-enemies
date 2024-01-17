extends BrigdeAnimal

class_name BridgeSquirrel

func _init():
	source_id = 3
	atlas_pos = Vector2i.ZERO
	body_cells = [Vector2i(0,0),Vector2i(0,-1)]
	attach_cells = []

func is_valid_tile_type(tile_type : BridgeBuilder.TILE_TYPE):
	return true
