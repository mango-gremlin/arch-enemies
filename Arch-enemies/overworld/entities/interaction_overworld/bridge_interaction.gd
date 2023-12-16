extends Node2D

# --- / 
# -- / 
# -- | base properties for bridge instance
var interaction_type: Interactable.InteractionType = Interactable.InteractionType.BRIDGE

# denotes id of bridge-level this will be linked to
@export var bridge_id:int
# string denoting what is shown upon interaction with bridge
@export var bridge_description: String

# could be a small preview of the level or whatever
@export var bridge_image:Image

# --- / 
# -- / further properties could be 
# - reward after completion 
# - // also denoted in #134 
# --> denote whether the bonus objective was achieved or not 


func _ready():
	var interactionspot_object = get_node("interactionspot")
	interactionspot_object.parent_node = self
	interactionspot_object.interact_type = interaction_type


## --- / 
## -- / INTERACTION WITH PLAYER 


# returns dialogue-String for displaying in dialogue-Box
# if item obtainable -> return item_dialogue_succes
# else -> return item_dialogue_failure
func obtain_description() -> String:
	return bridge_description

# gathers bridge Id linked to this interactionspot
func obtain_bridge_id() -> int:
	return bridge_id

# returns true if it was solved already 
# referenced in #137
func is_solved() -> bool:
	# TODO 
	# requires query in **singleton** to denote whether connection was done already or not 
	return false
