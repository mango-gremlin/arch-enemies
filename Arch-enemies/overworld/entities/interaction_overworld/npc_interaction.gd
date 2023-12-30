extends Node2D

#class_name NPC_interaction
# --- / 
# -- / 
# -- | base properties for npc instance
@export var npc_name:String
@export var npc_id:int
@export var npc_animal_type:Animal.AnimalType
@export var quest_type:NPC_interaction.Quest = NPC_interaction.Quest.NONE
@export var required_edge_start:int
@export var required_edge_dest:int
@export var required_item:Item.ItemType
@export var required_npc_id:int 
# quest-reward 
@export var quest_reward:NPC_interaction.QuestReward = NPC_interaction.QuestReward.NONE
@export var reward_item:Item.ItemType = Item.ItemType.NONE

# denotes NPC object tied to this node 
var interaction_type: Interactable.InteractionType = Interactable.InteractionType.NPC
@onready var npc_object:NPC_interaction 

func _ready():
	# constructing NPC accordingly
	npc_object = NPC_interaction.new(npc_name,npc_id,npc_animal_type)
	
	if quest_type != NPC_interaction.Quest.NONE :
		# updating conditions for quest behavior
		npc_object.set_quest_parameter(
			quest_type,
			required_item,
			required_npc_id,
			required_edge_start,
			required_edge_start)
		# setting reward_parameters
		npc_object.set_quest_reward(quest_reward,reward_item,npc_animal_type)
		
	# adding npc_object to list of globally known npcs 
	SingletonPlayer.add_npc_instance(npc_id,npc_object)
	print(npc_object.stringify_quest())
	# linking to interaction spot accordingly
	# helps to interact with interactionspot afterwards
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
	return npc_object.obtain_dialogue()

# checks whether conditions for completing quest were acquired 
# updates "is_recruited" accordingly
func check_quest_condition() -> bool:
	return npc_object.check_quest_condition()
# returns either Animal/Item if quest was complete before 
# if quest is not done, returns Item of Type "ItemType.NONE"
func request_reward(): 
	return npc_object.request_reward()

# returns formatted dialogue
# TODO should maybe contain the active state of the conversation 
func obtain_formatted_dialogue() ->String:
	# FIXME might not query from this interface but within player directly?
	return npc_object.obtain_formatted_dialogue()

# returns itemType, if itemtype is specified
# FIXME should be more abstract and matched against in "Player.gd"
func obtain_quest_item_type() -> Item.ItemType:
	return required_item

func set_quest_resolved():
	# FIXME might not query from this interface but within player directly?
	npc_object.set_quest_resolved()

func obtain_required_item() -> Item.ItemType:
	return required_item

