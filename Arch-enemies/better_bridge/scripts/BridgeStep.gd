class_name BridgeStep

var animal_type : Animal.AnimalType
var pos : Vector2i = Vector2i.ZERO
var prev_cells : Array[BridgeCell]

func _init(_type : Animal.AnimalType, _pos : Vector2i, _prev_cells : Array[BridgeCell]):
	animal_type = _type
	pos = _pos
	prev_cells = _prev_cells
