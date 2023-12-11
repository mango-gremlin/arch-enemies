extends Node2D

## base properties set for bridge interaction

@export var bridge_id:int
@export var difficulty:int
@export var description:String = "reserved for preview path of sprite"
var interaction_type: Interactable.InteractionType = Interactable.InteractionType.BRIDGE


func _ready():
	var interactionspot_object = get_node("interactionspot")
	interactionspot_object.interact_type = interaction_type
	interactionspot_object.interact_value = bridge_id
	# updating description 
	interactionspot_object.interact_label = description


## --- / 
## -- / INTERACTION WITH PLAYER 

# gathers bridge Id linked to this interactionspot
func obtain_bridge_id() -> int:
	return bridge_id

# 
