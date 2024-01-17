class_name AnimalAttach

var offset : Vector2i =  Vector2i.ZERO
var tile_type : TileType.Variants = TileType.Variants.NONE

func _init(_offset : Vector2i, _tile_type : TileType.Variants):
	offset = _offset
	tile_type = _tile_type
