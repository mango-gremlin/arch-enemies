class_name BridgeCell

var pos : Vector2i =  Vector2i.ZERO
var tile_type : TileType.Variants = TileType.Variants.NONE

func _init(_pos : Vector2i, _tile_type : TileType.Variants):
	pos = _pos
	tile_type = _tile_type
