extends Node2D

#class_name NPC_interaction
# --- / 
# -- / 
# -- | base properties for npc instance

# -- / FIXME REMOVE BECAUSE STORED IN NPC NOW !
# NPC can be flagged
# -> interaction with another npc required to obtain this one 
# -> item required to obtain this one 
# -> build a certain bridge ( or the itme behind it )
enum AnimalType{
	SNAKE,
	DEER,
	SQUIRREL,
	SPIDER,
	NONE
	#FOX.
	# possibly more 
}

# denotes Quest-Type of NPC
enum Quest{
	ITEM,
	BRIDGE,
	NPC,
	NONE,
}

# denotes which type of quest-reward is obtained 
# after solving npcs quest
enum QuestReward{
	ITEM,
	ANIMAL,
	NONE
}

var interaction_type: Interactable.InteractionType = Interactable.InteractionType.NPC

# denotes id of bridge-level this will be linked to
@export var npc_id:int = 0
# string denoting what is shown upon interaction with bridge
@export var npc_name: String
@export var npc_type:NPC_interaction.AnimalType
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
	if has_quest == Quest.NONE:
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
func obtain_dialogue() -> String:
	if is_recruited:
		return dialogue_quest_done
	else:
		return dialogue_quest_undone

# checks whether conditions for completing quest were acquired 
# updates "is_recruited" accordingly
func check_quest_condition() -> bool:
	# FIXME IMPROVE WRITING / CONDITIONS 
	if not is_recruited : 
	#TODO prone to change with better implementation of dialogue!
		match has_quest:
			Quest.ITEM:
				if check_item_condition():
					# matching item was provided 
					return true 
				return false 
			Quest.BRIDGE:
				if SingletonPlayer.check_bridge_connection(required_bridge_edge):
					return true 
				return false 
			Quest.NPC:
				if SingletonPlayer.check_npc_state(required_npc_id): 
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
		#return reward_item
		return true 
	return false 
	#return Item.ItemType.NONE
	

# returns either Animal/Item if quest was complete before 
# if quest is not done, returns Item of Type "ItemType.NONE"
func request_reward(): 
	# 
	if not is_recruited: 
		# check whether we satisfy the conditions
		if check_quest_condition(): 
			print("npc is done ")
			match quest_reward:
				QuestReward.ITEM:
					return reward_item
				QuestReward.ANIMAL:
					return npc_type
						
	return Item.new(Item.ItemType.NONE)

# returns formatted dialogue
# TODO should maybe contain the active state of the conversation 
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

