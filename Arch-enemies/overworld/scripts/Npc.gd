extends Node

# --- / 
# -- / file representing NPC within game 
class_name NPC_interaction 
#
# with this structure we making internally defined types available globally
# 
# -- / 
# Quests can be of one of the following types:
# -> interaction with another npc required to obtain this one 
# -> item required to obtain this one 
# -> build a certain bridge ( or the itme behind it )

# denotes Quest-Type of NPC
enum Quest{
	ITEM,
	BRIDGE,
	NPC,
	ALL,
	NONE,
}

# denotes which type of quest-reward is obtained 
# after solving npcs quest
enum QuestReward{
	ITEM,
	ANIMAL,
	BRIDGE,
	NONE
}

# --- / 
# -- / base properties
var npc_name:String
var npc_id:int
var npc_animal_type:Animal.AnimalType


# should not be set in case reward is of type NPC
var quest_reward:QuestReward = QuestReward.NONE
var reward_item:Item.ItemType = Item.ItemType.NONE
var reward_bridge:SingletonPlayer.BridgeEdge
var reward_animal:Animal.AnimalType = npc_animal_type
# amount of rewards for either Animals or Items
var reward_amount:int = 1

# --- / 
# -- / Quest specific properties
var quest_type:Quest = Quest.NONE
var required_item:Item.ItemType = Item.ItemType.NONE
var required_bridge_edge:SingletonPlayer.BridgeEdge 
var required_npc_id:int 

# denotes whether its quest was solved or not
var quest_resolved:bool = false 

# --- / 
# -- / Dialoque options
#FIXME placeholder for dialogue system
@export var dialogue_quest_undone: String = "quest undone so far"
@export var dialogue_quest_done :String = "quest is done"
# denotes in which state of the dialogue the npc is currently
# example: we just started talking to them and they now await an item from us 
var dialogue_state:int 

# --- / 
# -- / UI / Design 
var npc_sprite:Image



# --- /
# -- / class constructor 
func _init(
	received_name:String,
	received_id:int,
	received_animal_type:Animal.AnimalType
	):
	npc_name = received_name
	npc_id = received_id 
	npc_animal_type = received_animal_type

# --- / 
# -- / Basic interaction 

# returns npc name
func obtain_name() -> String:
	return npc_name

# returns id denoting the npc 
func obtain_npc_id() -> int:
	return npc_id

# returns id denoting the quest held by the npc ( they are the same ) 
func obtain_quest_id() -> int:
	return obtain_npc_id()

# returns rewardType
func obtain_reward_type() -> NPC_interaction.QuestReward:
	return quest_reward

# returns type of required item 
func obtain_required_item() -> Item.ItemType:
	return required_item

# returns whether this npc holds a quest (!= NONE) 
# or not 
func has_quest() -> bool:
	if quest_type != Quest.NONE:
		return true
	return false

func obtain_quest_state() -> bool:
	return quest_resolved

# --- / 
# -- / quest behavior / interaction 

# takes QuestType and stores the required value ( item, bridgeEdge,npcId ) 
# requires further information by further set_quest_ methods 
func set_quest_parameter(
	received_quest_type:Quest, 
	received_required_item:Item.ItemType,
	received_required_npc_id:int, 
	received_bridge_start:int,
	received_bridge_dest:int
	):
	quest_resolved = false
	
	quest_type = received_quest_type
	match quest_type:
		Quest.ITEM:
			required_item = received_required_item
		Quest.BRIDGE:
			var new_bridge:SingletonPlayer.BridgeEdge = SingletonPlayer.BridgeEdge.new(received_bridge_start,received_bridge_dest)
			required_bridge_edge = new_bridge 
		Quest.NPC: 
			required_npc_id = received_required_npc_id

# takes Quest reward type and both item and animal reward 
# sets those values accordingly within npc object
func set_quest_reward(
	received_quest_reward:QuestReward,
	received_reward_item:Item.ItemType,
	received_reward_animal:Animal.AnimalType,
	received_reward_amount:int,
	received_reward_bridge:SingletonPlayer.BridgeEdge
	):
	quest_reward = received_quest_reward
	match quest_reward: 
		QuestReward.ITEM:
			reward_item = received_reward_item
			reward_amount = received_reward_amount
		QuestReward.ANIMAL:
			reward_animal = received_reward_animal 
			reward_amount = received_reward_amount
		QuestReward.BRIDGE:
			# adding bridgeEdge that will be connected 
			reward_bridge = received_reward_bridge


# sets quest_resolved() to true 
func set_quest_resolved():
	quest_resolved = true 

# checks whether conditions for completing quest were acquired 
# returns this state as boolean 
# true if condition met
# false otherwise
func check_quest_condition() -> bool:
	# FIXME IMPROVE WRITING / CONDITIONS 
	if not quest_resolved : 
	#TODO prone to change with better implementation of dialogue!
		match quest_type:
			NPC_interaction.Quest.ITEM:
				if check_item_condition():
					# matching item was provided 
					return true 
				return false 
			NPC_interaction.Quest.BRIDGE:
				if SingletonPlayer.check_bridge_connection(required_bridge_edge):
					return true 
				return false 
			NPC_interaction.Quest.NPC:
				if SingletonPlayer.check_dialogue_finished(required_npc_id):
					# visited npc already 
					return true 
				return false 
			NPC_interaction.Quest.ALL:
				var quest_states:Dictionary = SingletonPlayer.obtain_all_quest_states()
				var all_quests_solved:bool = quest_dict_is_solved(quest_states)
				print(all_quests_solved)
				return all_quests_solved
			_:
				return false 
	return true

func check_item_condition() -> bool:
	var item_in_inventory:bool = SingletonPlayer.request_item(required_item)
	if item_in_inventory: 
		# gathered requested item --> condition met!
		return true 
	return false 

# returns either Animal/Item or BridgeEdge if quest was complete before 
# if quest is not done, returns 
# Item of Type "ItemType.NONE" 
# Animal of Type "Animal.AnimalType.NONE"
# BridgeEdge of Type "BridgeEdge(0,0) with BridgeLevelPathState.NONE
func request_reward() -> Dictionary: 
	# 
	if not quest_resolved: 
		# check whether we satisfy the conditions
		if check_quest_condition(): 
			print("met npc requirements")
			# decreasing item amount by 1  in inventory!
			SingletonPlayer.use_item(required_item)
			# updating internal state
			quest_resolved = true 
			match quest_reward:
				NPC_interaction.QuestReward.ITEM:
					var item_reward: Dictionary = {
						"type": reward_item,
						"amount": reward_amount
					}
					return item_reward
				NPC_interaction.QuestReward.ANIMAL:
					# FIXME creates an invariant for received interactions!
					var animal_reward: Dictionary = {
						"type": npc_animal_type,
						"amount": reward_amount
					}
					return animal_reward
				NPC_interaction.QuestReward.BRIDGE:
					var bridge_reward: Dictionary = {
						"bridge_object":  reward_bridge
					}
					return bridge_reward
						
	# FIXME improve readability 
	# FIXME reduce complexity of this simple statement
	print("requirements not met!")
	match quest_reward:
		NPC_interaction.QuestReward.ITEM:
			var item_reward: Dictionary = {
						"type": Item.ItemType.NONE,
						"amount": 0
					}
			return item_reward
		NPC_interaction.QuestReward.ANIMAL:
			var animal_reward: Dictionary = {
						"type": Animal.AnimalType.NONE,
						"amount": 0
					}
			return animal_reward
		NPC_interaction.QuestReward.BRIDGE:
			var unsolved_edge:SingletonPlayer.BridgeEdge= SingletonPlayer.BridgeEdge.new(0,0)
			unsolved_edge.set_availability(SingletonPlayer.BridgeLevelPathState.NONE)
			var unsolved_bridge: Dictionary = {
				"bridge_object":  unsolved_edge
				}
			return unsolved_bridge
			#return unsolved_edge
	#FIXME never reached
	return {}

# constructs string representation of current quest 
# returns this String
func stringify_quest() -> String: 
	# query name from npc that requires Quest 
	# TODO  query from global state of all npcs contained ( according to their ID!
	var source_npc_name:String = obtain_name()
	var requirement_string:String 
	match quest_type:
		Quest.ITEM:
			var target_item:String = Item.set_item_name(required_item)
			requirement_string = " wants you to gather " + target_item
		Quest.BRIDGE:
			var string_format = " wants you to connect %d with %d " 
			requirement_string = string_format % [required_bridge_edge.start_id, required_bridge_edge.dest_id]
			pass
		Quest.NPC:
			var target_npc:NPC_interaction  = SingletonPlayer.obtain_npc_object(required_npc_id)
			var target_npc_name = target_npc.obtain_name()
			requirement_string = " wants you to talk to " + target_npc_name 
		Quest.ALL:
			#gather all  quests available right now
			# FIXME
			var quest_states:Dictionary = SingletonPlayer.obtain_all_quest_states()
			var quest_list:String = transform_quest_dict_to_string(quest_states)
			requirement_string = " wants you to solve: \n" +quest_list
			return requirement_string
		_:
			# no quest given for the npc
			return ""
			
	
	# combine name of npc with its quest
	var combined_message = source_npc_name + requirement_string 
	return combined_message

# FIXME could not be a primitve datatype!
func transform_quest_dict_to_string(quests:Dictionary) -> String:
	var resulting_list:String = ""
	for quest in quests: 
		var quest_solved:bool = quests[quest]
		if not quest_solved:
			# adding to list, as its unsolved
			resulting_list += "\n" + quest
	return resulting_list

# FIXME could not be a primitve datatype, same as transform_quest_dict_to_string
# takes dictionary of quests ( key:quest-string, value:issolved --> boolean) 
# if one condition was not solved, return false
func quest_dict_is_solved(quests:Dictionary) -> bool:
	for quest in quests:
		# iterate over all booleans received for quests
		var quest_solved:bool = quests[quest]
		if not quest_solved: 
			return false
	return true

# --- / 
# -- / Dialogue interaction 
# FIXME only temporary until dialogue system was implemented

# return the dialogue based on condition ( quest done / undone ) 
func obtain_dialogue() -> String:
	if quest_resolved:
		return dialogue_quest_done
	else:
		return stringify_quest()
		
func interaction_label() ->String:
	return dialogue_quest_done

# returns formatted dialogue
# FIXME placehold for dialogue-system
func obtain_formatted_dialogue() ->String:
	var dialogue_string:String = "%s :: %s!"
	var received_name = obtain_name()
	var received_dialogue = obtain_dialogue()
	var combined_message:String = dialogue_string % [received_name, received_dialogue]
	return combined_message


