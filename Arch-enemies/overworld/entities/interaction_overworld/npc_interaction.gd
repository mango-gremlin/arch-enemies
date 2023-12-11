extends Node2D

# --- / 
# -- / 
# -- | base properties for npc instance

# -- / 
# NPC can be flagged
# -> interaction with another npc required to obtain this one 
# -> item required to obtain this one 
# -> build a certain bridge ( or the itme behind it )
enum AnimalType{
	SNAKE,
	DEER,
	SQUIRREL,
	SPIDER,
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
@export var npc_type:AnimalType # type animal 
@export var has_quest:Quest 

# should not be set in case reward is of type NPC
@export var quest_reward:QuestReward
@export var reward_item:Item.ItemType

# --- / 
# -- / Quest descriptions / setup
@export var required_item:Item.ItemType
#denotes required bridge id built
@export var required_bridge_id:int

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
var received_item:Item = Item.new(Item.ItemType.NONE)


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
func check_quest_condition():
	#TODO prone to change with better implementation of dialogue!
	match has_quest:
		Quest.ITEM:
			if received_item.item_type == required_item:
				# matching item was provided 
				is_recruited = true
		Quest.BRIDGE:
			#TODO check in "Player-Singleton, whether player built certain bridge!
			is_recruited = true 
		Quest.NPC:
			#TODO check in "Player-Singleton, whether communication happened with given npc already 
			is_recruited = true 
		_:
			pass

# returns either Animal/Item if quest was complete before 
# if quest is not done, returns Item of Type "ItemType.NONE"
func obtain_value(): 
	if is_recruited:
		print("npc is done ")
		match quest_reward:
			QuestReward.ITEM:
				return Item.new(reward_item)
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
