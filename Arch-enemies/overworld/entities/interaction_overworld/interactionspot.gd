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
#var interact_value = "no interaction"

# debugging : denotes what this interaction is about
#var interact_label = " "

# --- / 
# -- / necessary options for ITEM

# --- / 
# -- / necessary options for BRIDGE
var bridge_id:int
# should be referencing to the to the bridge-game 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# --- / 
# -- / 
# called whenever player wants to interact with area
# depending on set type different interactions will happen
func interact_with_area() -> Dictionary:
	print("interacting with area")
	match interact_type:
		InteractionType.ITEM:
			# TODO refactor
			# querying item to receive 
			var received_item = parent_node.obtain_item()
			var received_dialogue = parent_node.obtain_dialogue()
			return {"item": received_item, "dialogue": received_dialogue}
		InteractionType.BRIDGE:
			# TODO  refactor
			var is_solved = parent_node.is_solved()
			var received_bridge_id:int = parent_node.obtain_bridge_id()
			var received_description:String = "this level was solved already"
			if not is_solved:
				received_description = parent_node.obtain_description()
			return {"id": received_bridge_id, "description": received_description}
			#var received_dialogue =
			
		InteractionType.NPC:
			# TODO refactor
			# FIXME  requires state management to check where the dialogue is based and structured in
			# TODO might be a separate scene that is called to run player through the interaction?
			var dialogue_string = parent_node.obtain_formatted_dialogue()
			var received_value = parent_node.obtain_value()
			var received_id = parent_node.obtain_id()
			
			# querying required item
			var required_item_type = parent_node.obtain_quest_item_type()
			# check if item in inventory of player
			
			# matching against received Value! 
			#match received_value:
			# FIXME requires enum of Type "QUEST" to match against!
				
			return {"dialogue":dialogue_string,"value":received_value,"npc_id":received_id}
		_: 
			return {}
			pass
	
