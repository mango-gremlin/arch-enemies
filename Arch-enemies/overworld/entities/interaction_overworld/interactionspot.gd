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
			var interaction : InteractionValue = interact_item()
			return interaction
		InteractionType.BRIDGE:
			# FIXME this checking is not necessary --> we will see whether it was solved
			# when using the returning value ( and check whether it was solved!)
			#var is_solved = parent_node.is_solved()
			#if not is_solved: 
			var interaction:InteractionValue = interact_bridge()
			return interaction
		InteractionType.NPC:
			# TODO refactor
			# FIXME  requires state management to check where the dialogue is based and structured in
			# TODO might be a separate scene that is called to run player through the interaction?
			# within a simple interaction witn an NPC: 
			# talk to them --> check whether we've talked already 
			# if they have a quest --> get the required item 
			# with required_item --> check if user owns it --> update their inventory and the reward-value
			var received_id = parent_node.obtain_id()
			var dialogue_string = parent_node.obtain_formatted_dialogue()
			var required_item = parent_node.obtain_required_item()
			
			# only useful when we have an item-reward!
			# contains value retrieved from querying status 
			var received_reward = parent_node.check_and_return_reward()
				
			var interaction_dict:Dictionary = {
				"dialogue":dialogue_string,
				"reward":received_reward,
				"npc_id":received_id
				}
			var interaction : InteractionValue = InteractionValue.new(InteractionType.NPC, interaction_dict)
			return interaction
		_: 
			return 
			pass
	
# handles interaction with bridge, by returning 
# edge and description of selected bridge 
func interact_bridge() -> InteractionValue:
# upon interaction with a bridge: 
# check the following: 
# solved already? 
#	true  -> dont do anything 
# 	false -> display information and allow to play game too 
# gathering information to return 
	var received_bridge_edge:SingletonPlayer.BridgeEdge = parent_node.obtain_bridge_edge()
	var received_description = parent_node.obtain_description()
	var queried_values:Dictionary = {
		"bridge_edge" : received_bridge_edge,
		"text" : received_description,
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
