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

class InteractionValue: 
	# denotes interaction type of given interactionValue
	var type:InteractionType 
	var valueDictionary:Dictionary 
	
	func _init(newType:InteractionType, value:Dictionary):
		type = newType
		valueDictionary = value 
		

# --- / 
# -- / base properties 
var parent_node:Node2D

# defines type of action, used to identify what to do next ... 
var interact_type:InteractionType = InteractionType.DEBUG

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# --- / 
# -- / 
# called whenever player wants to interact with area
# depending on set type different interactions will happen
func interact_with_area() -> InteractionValue:
	print("interacting with area")
	match interact_type:
		InteractionType.ITEM:
			var interaction:InteractionValue = interact_item()
			return interaction
		InteractionType.BRIDGE:
			var interaction:InteractionValue = interact_bridge()
			return interaction
		InteractionType.NPC:
			var interaction:InteractionValue = interact_npc()
			return interaction
		_: 
			return 
			pass
	
# handles interaction with bridge, by returning 
# edge and description of selected bridge 
func interact_bridge() -> InteractionValue:
# gathering information to return 
	var received_bridge_edge:SingletonPlayer.BridgeEdge = parent_node.obtain_bridge_edge()
	var received_description:String = parent_node.obtain_description()
	var received_bridge_status:bool = parent_node.is_solved()
	var queried_values:Dictionary = {
		"bridge_edge" : received_bridge_edge,
		"text" : received_description,
		"issolved" : received_bridge_status
	}
	var interaction_result:InteractionValue = InteractionValue.new(InteractionType.BRIDGE, queried_values)
	return interaction_result

# handles interaction with bridge, by returning 
# edge and description of selected bridge 
func interact_item() -> InteractionValue: 
# querying item to receive 
	var received_item = parent_node.obtain_item()
	var received_dialogue = parent_node.obtain_dialogue()
	# construction interactionValue
	var queried_values:Dictionary = {
		"item": received_item, 
		"text": received_dialogue,
	}
	var interaction_result:InteractionValue = InteractionValue.new(InteractionType.ITEM,queried_values)
	return interaction_result

# handles interaction with an npc, 
# returns "InteractionValue" with InteractionType 
# Dictionary contains: npc_id, dialogue String, reward-item, reward-type 
func interact_npc() -> InteractionValue: 
	# FIXME  requires state management to check where the dialogue is based and structured in
	# TODO might be a separate scene that is called to run player through the interaction?	
	var received_id = parent_node.obtain_id()
	var dialogue_string = parent_node.quest_done()
	var required_item = parent_node.obtain_required_item()
	
	# only useful when we have an item-reward!
	# contains value retrieved from querying status 
	var received_reward = parent_node.request_reward()
	var reward_type = parent_node.obtain_reward_type()
	
	var interaction_dict:Dictionary = {
		"npc_id":received_id,
		"dialogue":dialogue_string,
		"reward":received_reward,
		"reward_type": reward_type
		
		}
	var interaction:InteractionValue = InteractionValue.new(InteractionType.NPC, interaction_dict)
	return interaction
