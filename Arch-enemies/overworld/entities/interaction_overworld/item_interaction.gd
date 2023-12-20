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
@export var item_amount:int = 1

# denotes item Object
var item_instance:Item

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
	# set item_type
	# FIXME may not be necessary as we only interact with this instance anyway!
	#interactionspot_object.item_type = item_type
	#interactionspot_object.item_description = item_dialogue_box
	
	## -- / initialize item
	# FIXME should not be instantiated with every creation 
	# generating new item
	item_instance = Item.new(item_type)

# checks whether item can be obtained by player 
# returns true, if possible
# returns false, otherwise
func is_obtainable_by_player() -> bool:
	#FIXME should check on given criteria for player object
	# could be get_criteria_threshold(criteria:enum)
	var player_threshold_criteria:int = 10
	# check whether player meets set criteria
	if obtain_threshold < player_threshold_criteria and item_amount != 0:
		return true
	return false

# returns contained item and reduced amount available 
# returns nothing if requirement is not met 
func obtain_item() -> Item:
	if is_obtainable_by_player():
		# can be obtained, returning and updating count for intenral representation 
		item_amount -= 1
		# FIXME construct a struct that contains
		# ITEM ( if available ) 
		# DIALOGUE-OPTION
		return item_instance
	else: 
		print("not obtainable")
		# is not obtainable
		# FIXME NO NULL TYPES!
		return Item.new(Item.ItemType.NONE)

# returns dialogue-String for displaying in dialogue-Box
# if item obtainable -> return item_dialogue_succes
# else -> return item_dialogue_failure
func obtain_dialogue() -> String:
	if is_obtainable_by_player():
		return item_dialogue_success
	else:
		return item_dialogue_failure
