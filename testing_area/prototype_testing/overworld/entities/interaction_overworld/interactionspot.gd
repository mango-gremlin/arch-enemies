extends Area2D
class_name Interactable

# denotes interaction type
enum InteractionType { 
	NPC, # denotes interaction with NPC
	BRIDGE, # denotes BRIDGE-game
	BLOCKADE, # denotes areas where a bridge could've been built, is checked against player
	ITEM, # denotes interaction with Spot that supplies item
	DEBUG, # denotes DEBUG interactions
}

# --- / 
# -- / base properties 
# defines type of action, used to identify what to do next ... 
@export var interact_type:InteractionType = InteractionType.DEBUG

# denotes the value contained 
var interact_value = "no interaction"

# debugging : denotes what this interaction is about
@export var interact_label = "none"

# --- / 
# -- / necessary options for ITEM
@export var item_type:Item.ItemType = Item.ItemType.NOTHING
@export var item_description:String = "description of item, is showcased on interaction"

# --- / 
# -- / necessary options for BRIDGE
var bridge_id:int
# should be referencing to the to the bridge-game 








# Called when the node enters the scene tree for the first time.
func _ready():
	# constructing the according type:
	match interact_type: 
		InteractionType.ITEM:
			# generating new item
			var newItem = Item.new(item_type,item_description)
			interact_label = newItem.item_description
			interact_value = newItem
		InteractionType.NPC:
			pass
		InteractionType.BRIDGE:
			pass
			#interact_value = bridge_id
			# should be replaced by DATASTRUCTURE denoting a bridge-Level
			
		InteractionType.BLOCKADE:
			pass
		InteractionType.DEBUG:
			pass
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
