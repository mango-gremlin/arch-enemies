class_name BrigdeAnimal

var source_id : int = 0
var atlas_pos : Vector2i = Vector2i.ZERO
var body_cells : Array[Vector2i]
var attach_cells : Array[AnimalAttach]

func is_valid_tile_type(tile_type : BridgeBuilder.TILE_TYPE):
	pass
