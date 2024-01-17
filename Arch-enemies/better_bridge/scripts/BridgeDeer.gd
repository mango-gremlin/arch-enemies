extends BrigdeAnimal

class_name BridgeDeer

func _init():
	source_id = 0
	atlas_pos = Vector2i.ZERO
	body_cells = [Vector2i(0,0),Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1),Vector2i(-1,1),Vector2i(1,-1)]
	attach_cells = [
		AnimalAttach.new(Vector2i(-2,1), BridgeBuilder.TILE_TYPE.VERTICAL),
		AnimalAttach.new(Vector2i(-2,0), BridgeBuilder.TILE_TYPE.VERTICAL),
		AnimalAttach.new(Vector2i(-1,-1), BridgeBuilder.TILE_TYPE.HORIZONTAL),
		AnimalAttach.new(Vector2i(0,-2), BridgeBuilder.TILE_TYPE.HORIZONTAL),
		AnimalAttach.new(Vector2i(1,-2), BridgeBuilder.TILE_TYPE.HORIZONTAL),
		AnimalAttach.new(Vector2i(1,0), BridgeBuilder.TILE_TYPE.VERTICAL),
		AnimalAttach.new(Vector2i(1,1), BridgeBuilder.TILE_TYPE.VERTICAL),
	]

func is_valid_tile_type(tile_type : BridgeBuilder.TILE_TYPE):
	return true
