extends BrigdeAnimal

class_name BridgeSquirrel

func _init():
	source_id = 3
	atlas_pos = Vector2i.ZERO
	body_cells = [Vector2i(0,0),Vector2i(0,-1)]
	attach_cells = [
		BridgeCell.new(Vector2i(-1,0), TileType.Variants.VERTICAL),
		BridgeCell.new(Vector2i(1,0), TileType.Variants.VERTICAL),
		BridgeCell.new(Vector2i(1,-1), TileType.Variants.VERTICAL),
		BridgeCell.new(Vector2i(1,-1), TileType.Variants.VERTICAL),
		BridgeCell.new(Vector2i(0,-2), TileType.Variants.HORIZONTAL),
	]

func is_valid_tile_type(tile_type : TileType.Variants) -> bool:
	return (tile_type == TileType.Variants.HORIZONTAL or 
		tile_type == TileType.Variants.VERTICAL or
		tile_type == TileType.Variants.NONE)
