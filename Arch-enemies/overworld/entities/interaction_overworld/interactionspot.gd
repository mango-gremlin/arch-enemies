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
var parent_node:Node2D

# defines type of action, used to identify what to do next ... 
var interact_type:InteractionType = InteractionType.DEBUG

# denotes the value contained 
var interact_value = "no interaction"

# debugging : denotes what this interaction is about
var interact_label = " "

# --- / 
# -- / necessary options for ITEM
var item_type:Item.ItemType = Item.ItemType.NOTHING
var item_description:String = "description of item, is showcased on interaction"

# --- / 
# -- / necessary options for BRIDGE
var bridge_id:int
# should be referencing to the to the bridge-game 






# Called when the node enters the scene tree for the first time.
func _ready():
	# debugging 
	# constructing the according type:
	match interact_type: 
		InteractionType.ITEM:
			# FIXME should not be instantiated with every creation 
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
			

# --- / 
# -- / 
# called whenever player wants to interact with area
func interact_with_area():
	print("interacting with area")
	match interact_type:
		InteractionType.ITEM:
			var received_value = parent_node.signal_existence()
			print(received_value)
			# interact according to item requirements
			pass
			
		_: 
			pass
	
