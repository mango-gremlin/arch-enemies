extends BrigdeAnimal

class_name BridgeSnake

func _init():
	source_id = 1
	atlas_pos = Vector2i.ZERO
	body_cells = [Vector2i(0,0), Vector2i(-1,0), Vector2i(-2,0), Vector2i(1,0), Vector2i(2,0)]
	attach_cells = [
		AnimalAttach.new(Vector2i(3,0), TileType.Variants.FORBIDDEN),
		AnimalAttach.new(Vector2i(3,1), TileType.Variants.FORBIDDEN),
		AnimalAttach.new(Vector2i(3,-1), TileType.Variants.FORBIDDEN),
		AnimalAttach.new(Vector2i(2,1), TileType.Variants.FORBIDDEN),
		AnimalAttach.new(Vector2i(2,-1), TileType.Variants.FORBIDDEN),
		
		AnimalAttach.new(Vector2i(1,-1), TileType.Variants.HORIZONTAL),
		AnimalAttach.new(Vector2i(0,-1), TileType.Variants.HORIZONTAL),
		AnimalAttach.new(Vector2i(-1,-1), TileType.Variants.HORIZONTAL),
		AnimalAttach.new(Vector2i(-1,-1), TileType.Variants.HORIZONTAL),
		AnimalAttach.new(Vector2i(-2,-1), TileType.Variants.HORIZONTAL),
		
		AnimalAttach.new(Vector2i(1,1), TileType.Variants.VERTICAL),
		AnimalAttach.new(Vector2i(0,1), TileType.Variants.VERTICAL),
		AnimalAttach.new(Vector2i(-1,1), TileType.Variants.VERTICAL),
		AnimalAttach.new(Vector2i(-1,1), TileType.Variants.VERTICAL),
		AnimalAttach.new(Vector2i(-2,1), TileType.Variants.VERTICAL),
		AnimalAttach.new(Vector2i(-3,1), TileType.Variants.VERTICAL),
	]

func is_valid_tile_type(tile_type : TileType.Variants) -> bool:
	return (tile_type == TileType.Variants.HORIZONTAL or
		tile_type == TileType.Variants.NONE)
		
func check_custom_placement_condition(pos : Vector2i, map : BridgeMap, placement_layer : int):
	return not (map.get_tile_type(placement_layer, pos + Vector2i(3,0)) == TileType.Variants.BODY or
		map.get_tile_type(placement_layer, pos + Vector2i(3,1)) == TileType.Variants.BODY or
		map.get_tile_type(placement_layer, pos + Vector2i(3,-1)) == TileType.Variants.BODY or
		map.get_tile_type(placement_layer, pos + Vector2i(2,1)) == TileType.Variants.BODY or
		map.get_tile_type(placement_layer, pos + Vector2i(2,-1)) == TileType.Variants.BODY)
