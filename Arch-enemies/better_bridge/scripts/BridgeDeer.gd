extends BrigdeAnimal

class_name BridgeDeer

func _init():
	source_id = 0
	atlas_pos = Vector2i.ZERO
	body_cells = [Vector2i(0,0),Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1),Vector2i(-1,1),Vector2i(1,-1)]
	attach_cells = [
		BridgeCell.new(Vector2i(-2,1), TileType.Variants.VERTICAL),
		BridgeCell.new(Vector2i(-2,0), TileType.Variants.VERTICAL),
		BridgeCell.new(Vector2i(-1,-1), TileType.Variants.HORIZONTAL),
		BridgeCell.new(Vector2i(0,-2), TileType.Variants.HORIZONTAL),
		BridgeCell.new(Vector2i(1,-2), TileType.Variants.HORIZONTAL),
		BridgeCell.new(Vector2i(1,0), TileType.Variants.VERTICAL),
		BridgeCell.new(Vector2i(1,1), TileType.Variants.VERTICAL),
	]

func is_valid_tile_type(tile_type : TileType.Variants) -> bool:
	return (tile_type == TileType.Variants.HORIZONTAL or 
		tile_type == TileType.Variants.SHALLOW_WATER or
		tile_type == TileType.Variants.WATER or
		tile_type == TileType.Variants.NONE)
