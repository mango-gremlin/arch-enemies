extends BrigdeAnimal

class_name BridgeSpider

func _init():
	source_id = 2
	atlas_pos = Vector2i.ZERO
	body_cells = [Vector2i(0,0)]
	attach_cells = [
		AnimalAttach.new(Vector2i(1,0), TileType.Variants.HORIZONTAL),
		AnimalAttach.new(Vector2i(-1,0), TileType.Variants.HORIZONTAL),
		AnimalAttach.new(Vector2i(0,1), TileType.Variants.HORIZONTAL),
		AnimalAttach.new(Vector2i(0,-1), TileType.Variants.HORIZONTAL),
	]

func is_valid_tile_type(tile_type : TileType.Variants) -> bool:
	return (tile_type == TileType.Variants.HORIZONTAL or 
		tile_type == TileType.Variants.VERTICAL or 
		tile_type == TileType.Variants.NONE)
