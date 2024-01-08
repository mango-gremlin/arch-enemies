extends Node2D

# --- / 
# -- / providing information that are 
# -- | piped to _interactionspot_ upon initialization

# ---- 
# FIXME : load the state of this item node upon world construction 
# this requires the usage of an **item_interaction_spot_id 
# those have to be stored and initialized accordingly
# ----

# choose which item is contained
var interaction_type: Interactable.InteractionType = Interactable.InteractionType.ITEM
@export var item_type:Item.ItemType
# FIXME this value is not persistent but resets with every game! 
# TODO convert to Issue on Github to track!
@export var item_amount:int = 1
@export var itemspot_id:int = 0

# denotes item Object
#var item_instance:Item

# string denoting what is shown upon gathering the item 
@export var item_dialogue_success: String
@export var item_dialogue_failure: String

# -- /
# - / conditions to obatin item
@export var obtain_threshold:int
# FIXME construct ENUM representing different factions 
@export var required_faction:int




# run upon instantiating this node in scene
func _ready():
	# gathering child node
	var interactionspot_object = get_node("interactionspot")
	# set interaction type for child node
	interactionspot_object.parent_node = self
	interactionspot_object.interact_type = interaction_type

# checks whether item can be obtained by player 
# returns true, if possible
# returns false, otherwise
func is_obtainable_by_player() -> bool:
	if item_amount != 0:
		return true
	return false

# returns contained item and reduced amount available 
# returns nothing if requirement is not met 
func obtain_item() -> Item.ItemType:
	if is_obtainable_by_player():
		# can be obtained, returning and updating count for internal representation 
		item_amount -= 1
		return item_type
	else: 
		print("not obtainable")
		# signals an empty return --> wont be saved in inventory
		return Item.ItemType.NONE

# returns dialogue-String for displaying in dialogue-Box
# if item obtainable -> return item_dialogue_succes
# else -> return item_dialogue_failure
func obtain_dialogue() -> String:
	if is_obtainable_by_player():
		return item_dialogue_success
	else:
		return item_dialogue_failure
