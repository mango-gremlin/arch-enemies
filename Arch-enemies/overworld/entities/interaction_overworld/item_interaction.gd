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
# static references to child nodes
@onready var linked_sprite:Sprite2D = $item_sprite
@onready var linked_indicator:AnimatedSprite2D = $InteractionIndicator
@onready var interactionspot_child:Interactable = $interactionspot

# run upon instantiating this node in scene
func _ready():
	set_item_sprite()
	# plays animation of floating indicator (tells u to press E)
	$InteractionIndicator.play("indication")
	
	# update available amount 
	if SingletonPlayer.itemspot_state.has(itemspot_id):
		print("found saved state, restoring")
		item_amount = SingletonPlayer.itemspot_state[itemspot_id]
	
	# set interaction type for child node
	interactionspot_child.parent_node = self
	interactionspot_child.interact_type = interaction_type
	update_visibility()

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
		update_visibility()
		SingletonPlayer.itemspot_state[itemspot_id] = item_amount
		return item_type
	else: 
		print("not obtainable")
		# signals an empty return --> wont be saved in inventory
		return Item.ItemType.NONE

# --- / 
# -- / VISUALIZATION
# this section is for visualization within the overworld 

# deriving sprite to load from item type, stolen from npc_interaction 
func set_item_sprite():
	# initialize reference
	var path_to_sprite:String 
	match item_type:
		Item.ItemType.EGG: 
			path_to_sprite = "res://assets/art/objects/overworld_items/item_egg.png"
		Item.ItemType.EVIDENCE:
			path_to_sprite = "res://assets/art/objects/overworld_items/item_evidence.png"
		Item.ItemType.HAZELNUT: 
			path_to_sprite = "res://assets/art/objects/overworld_items/item_hazelnut.png"
		Item.ItemType.FLIES:
			path_to_sprite = "res://assets/art/objects/overworld_items/item_fly.png"
	# loading texture 
	var item_sprite:Texture2D = load(path_to_sprite)
	linked_sprite.texture = item_sprite

# hides sprite of item if resource depleted
func update_visibility():
		linked_sprite.visible = is_obtainable_by_player()
		linked_indicator.visible = is_obtainable_by_player()
		
	
