extends Node2D

#class_name NPC_interaction
# --- / 
# -- / 
# -- | base properties for npc instance

# -- / FIXME REMOVE BECAUSE STORED IN NPC NOW !
# not fully implemented your NPC_interaction, i don't see the necessarity yet
var interaction_type: Interactable.InteractionType = Interactable.InteractionType.NPC

# denotes id of bridge-level this will be linked to
@export var npc_id:int = 0
# string denoting what is shown upon interaction with bridge
@export var npc_name: String
@export var npc_type:SingletonPlayer.AnimalType
@export var has_quest:NPC_interaction.Quest

# should not be set in case reward is of type NPC
@export var quest_reward:NPC_interaction.QuestReward
@export var reward_item:Item.ItemType

# --- / 
# -- / Quest descriptions / setup
@export var required_item:Item.ItemType
#denotes required connection
# FIXME maybe find simpler representation
#@export var required_bridge_edge: SingletonPlayer.BridgeEdge
@export var required_edge_start:int
@export var required_edge_dest:int
@onready var required_bridge_edge:SingletonPlayer.BridgeEdge

# denotes required ncp_id to talk with
@export var required_npc_id:int 

# --- / 
# -- / Dialoque options
#FIXME 
# requires option to represent and set a dialogue

# this is our created dialogue
# THIS IS NOT A GOOD SOLUTION, GODOT DOESN'T ALLOW FOR SETTING NON NODE OBJECT AS @export
# two solutions: create node in scope for each dialogue or a dict npc_id, dialogue_data
var dialogue_data: Dialogue_Data = ExampleData.new()

@export var dialogue_quest_undone: String = "quest undone so far"
@export var dialogue_quest_done :String = "quest is done"

# denotes whether they are already part or not
var is_recruited:bool = false

# denotes 
@export var npc_sprite:Image

# --- / 
# -- / further properties could be 
# - reward after completion 
# - // also denoted in #134 

# denotes item given by player 
var received_item:Item.ItemType = Item.ItemType.NONE


func _ready():
	# if no quest was selected, we automatically set it to "done"
	match has_quest:
		NPC_interaction.Quest.BRIDGE: 
			required_bridge_edge = SingletonPlayer.BridgeEdge.new(required_edge_start,required_edge_dest)
			
		_:
			is_recruited = true 
		
	
	# linking to interaction spot accordingly
	var interactionspot_object = get_node("interactionspot")
	interactionspot_object.parent_node = self
	interactionspot_object.interact_type = interaction_type


# --- / 
# -- / interaction with player 

# returns ncp id
func obtain_id() -> int:
	return npc_id

# returns rewardType
func obtain_reward_type() -> NPC_interaction.QuestReward:
	return quest_reward

# returns npc name
func obtain_name() -> String:
	return npc_name

# return the dialogue based on conditio ( quest done / undone ) 
# @Evelyn: check_quest_condition contains the new finished condition, where do you actually update is_recruited = true?
# didn't find that, so, a small work around to show that everything works
func obtain_dialogue() -> String:
	if is_recruited:
		return dialogue_quest_done # with my dialogue system, there's no need to show this anymore, it just opens the window
	else:
		return dialogue_quest_undone

# checks whether conditions for completing quest were acquired 
# updates "is_recruited" accordingly
func check_quest_condition() -> bool:
	# FIXME IMPROVE WRITING / CONDITIONS 
	if not is_recruited : 
	#TODO prone to change with better implementation of dialogue!
		match has_quest:
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
				if dialogue_data.finished: # correct?
					# visited npc already 
					return true 
				return false 
			_:
				return false 
	return true

func check_item_condition() -> bool:
	var is_obtained_item:bool = SingletonPlayer.request_item(required_item)
	if not is_obtained_item: 
		# gathered requested item --> condition met!
		return true 
	return false 

# returns either Animal/Item if quest was complete before 
# if quest is not done, returns Item of Type "ItemType.NONE"
func request_reward(): 
	# 
	if not is_recruited: 
		# check whether we satisfy the conditions
		if check_quest_condition(): 
			print("npc is done ")
			match quest_reward:
				NPC_interaction.QuestReward.ITEM:
					return reward_item
				NPC_interaction.QuestReward.ANIMAL:
					return npc_type
						
	# FIXME improve readability 
	# FIXME reduce complexity of this simple statement
	match quest_reward:
		NPC_interaction.QuestReward.ITEM:
				return Item.ItemType.NONE
		NPC_interaction.QuestReward.ANIMAL:
				return SingletonPlayer.AnimalType.NONE

# returns formatted dialogue
# TODO should maybe contain the active state of the conversation
# how? the message might be to long to display, see example dialogue
func obtain_formatted_dialogue() ->String:
	var dialogue_string:String = "%s :: %s!"
	var received_name = obtain_name()
	var received_dialogue = obtain_dialogue()
	var combined_message:String = dialogue_string % [received_name, received_dialogue]
	return combined_message

# returns itemType, if itemtype is specified
# FIXME should be more abstract and matched against in "Player.gd"
func obtain_quest_item_type() -> Item.ItemType:
	return required_item

func set_recruitment():
	is_recruited = true 

func obtain_required_item() -> Item.ItemType:
	return required_item

