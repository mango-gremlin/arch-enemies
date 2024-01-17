class_name AnimalAttach

var offset : Vector2i =  Vector2i.ZERO
var tile_type : BridgeBuilder.TILE_TYPE = BridgeBuilder.TILE_TYPE.NONE

func _init(_offset : Vector2i, _tile_type : BridgeBuilder.TILE_TYPE):
	offset = _offset
	tile_type = _tile_type
