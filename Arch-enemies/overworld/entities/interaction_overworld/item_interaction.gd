extends Node2D

# --- / 
# -- / providing information that are 
# -- | piped to _interactionspot_ upon initialization

# ---- 
# Idea: denoted in #133 on github!
# - items can be locked until a given threshold was met 
# ----

# choose which item is contained
var interaction_type: Interactable.InteractionType = Interactable.InteractionType.ITEM
@export var item_type:Item.ItemType

# FIXME this value is not persistent but resets with every game! 
# TODO convert to Issue on Github to track!
@export var item_amount:int = 2

# string denoting what is shown upon gathering the item 
@export var item_dialogue_box: String
@export var obtain_threshold:int
# 
@export var obtain_condition:String

# run upon instantiating this node in scene
func _ready():
	# gathering child node
	var interactionspot_object = get_node("interactionspot")
	# set interaction type for child node
	interactionspot_object.parent_node = self
	interactionspot_object.interact_type = interaction_type
	# setting description 
	interactionspot_object.item_type = item_type
	interactionspot_object.item_description = item_dialogue_box
	
	

# checks whether item can be obtained by player 
# returns true, if possible
# returns false, otherwise
func is_obtainable_by_player() -> bool:
	#FIXME should check on given criteria for player object
	# could be get_criteria_threshold(criteria:enum)
	var player_threshold_criteria:int = 10
	# check whether player meets set criteria
	if obtain_threshold  > player_threshold_criteria || item_amount == 0:
		return true
	return false

func signal_existence() -> String:
	return "this node was referenced from child"
