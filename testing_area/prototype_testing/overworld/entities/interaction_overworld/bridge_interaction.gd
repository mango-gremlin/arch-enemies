extends Node2D

## base properties set for bridge interaction

@export var bridge_id:int
@export var difficulty:int
@export var description:String = "reserved for preview path of sprite"

func _ready():
	var interactionspot_object = get_node("interactionspot")
	
	# updating bridge id accordingly
	interactionspot_object.interact_value = bridge_id
	# updating description 
	interactionspot_object.interact_label = description
