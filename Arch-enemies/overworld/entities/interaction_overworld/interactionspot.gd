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
			pass
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
func interact_with_area() -> Dictionary:
	print("interacting with area")
	match interact_type:
		InteractionType.ITEM:
			# querying item to receive 
			var received_item = parent_node.obtain_item()
			var received_dialogue = parent_node.obtain_dialogue()
			return {"item": received_item, "dialogue": received_dialogue}
			# interact according to item requirements
			pass
			
		_: 
			return {}
			pass
	
