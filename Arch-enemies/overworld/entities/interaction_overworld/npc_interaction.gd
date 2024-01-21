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
@export var reward_amount:int = 1

# for creating bridge-edge that will be solved if quest done
@export var reward_edge_start:int
@export var reward_edge_dest:int

# VISUALIZATION 
# only set whenever a special sprite is required for this npc!
@export var npc_special_sprite:Texture2D 

# denotes NPC object tied to this node 
var interaction_type: Interactable.InteractionType = Interactable.InteractionType.NPC
@onready var npc_object:NPC_interaction 

func create_npc() -> NPC_interaction:
	var new_npc:NPC_interaction = NPC_interaction.new(npc_name,npc_id,npc_animal_type)
	if SingletonPlayer.dictionary_npc.has(npc_id):
		# setting known npc for this interaction
		new_npc = SingletonPlayer.obtain_npc_object(npc_id)
		return new_npc
	
	# creating new npc
	# setting parameters for quests
	var reward_bridge = SingletonPlayer.BridgeEdge.new(-1,-1) # dummy value, no reward
	if quest_reward == NPC_interaction.QuestReward.BRIDGE:
		# creating bridge_edge that is contained within the NPC
		reward_bridge = SingletonPlayer.BridgeEdge.new(reward_edge_start,reward_edge_dest)
		var available_state:SingletonPlayer.BridgeLevelPathState = SingletonPlayer.BridgeLevelPathState.AVAILABLE
		reward_bridge.set_availability(available_state)
	
	if quest_type != NPC_interaction.Quest.NONE :
		# updating conditions for quest behavior
		new_npc.set_quest_parameter(
			quest_type,
			required_item,
			required_npc_id,
			required_edge_start,
			required_edge_dest)
		# setting reward_parameters
		new_npc.set_quest_reward(quest_reward,reward_item,npc_animal_type,reward_amount,reward_bridge)
	# adding npc_object to list of globally known npcs 
	SingletonPlayer.add_npc_instance(npc_id,new_npc)
	return new_npc
	
	
	

func _ready():
	# load visualization 
	set_npc_sprite()
	# linking to interaction spot accordingly
	# helps to interact with interactionspot afterwards
	var interactionspot_object = get_node("interactionspot")
	interactionspot_object.parent_node = self
	interactionspot_object.interact_type = interaction_type
	
	# constructing NPC accordingly
	npc_object = create_npc()
	# update name for dialogue associated with NPC! 
	# FIXME not a good solution because we leave the scope of where this should be done
	# WARNING npc_interaction should not take care, even know about a npc_dialogue!
	SingletonPlayer.set_dialogue_npc_name(npc_id)
	#print(npc_object.stringify_quest())

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
func obtain_formatted_dialogue() ->String:
	# FIXME might not query from this interface but within player directly?
	return npc_object.obtain_formatted_dialogue()
	
func interaction_label() ->String:
	return npc_object.interaction_label()

# returns itemType, if itemtype is specified
# FIXME should be more abstract and matched against in "Player.gd"
func obtain_quest_item_type() -> Item.ItemType:
	return required_item

func set_quest_resolved():
	# FIXME might not query from this interface but within player directly?
	npc_object.set_quest_resolved()

func obtain_required_item() -> Item.ItemType:
	return required_item

# --- / 
# -- / VISUALIZATION
# this section is for visualization within the overworld 

# deriving sprite to load from animal type
# OR a set special_sprite 
func set_npc_sprite():
	# initialize reference
	var referenced_sprite:Sprite2D = $Sprite2D
	
	if npc_special_sprite != null:
		referenced_sprite.texture = npc_special_sprite
		return
	var path_to_sprite:String 
	match npc_animal_type:
		Animal.AnimalType.SNAKE: 
			path_to_sprite = "res://assets/art/characters/snek.png"
		Animal.AnimalType.DEER:
			path_to_sprite = "res://assets/art/characters/deer.png"
		Animal.AnimalType.SQUIRREL: 
			path_to_sprite = "res://assets/art/characters/squirrel.png"
		Animal.AnimalType.SPIDER:
			path_to_sprite = "res://assets/art/characters/spider.png"
	# loading texture 
	var npc_sprite:Texture2D = load(path_to_sprite)
	referenced_sprite.texture = npc_sprite
