extends Node
# SINGLETON REPRESENTATION 
#
# This file accumulates necessary functionality to:
# - represent the player within the woorld 
# - track progress of game 
# - user profiles 

@onready var Savemanager = Savemanagement.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	Savemanager.load_config()
	# TODO add input to set 
	Savemanager.select_profile("default")

# -- Signals 
signal updated_item_inventory(new_inventory)
signal updated_animal_inventory(new_animal_inventory)
signal updated_quest_list(new_quest_list)

# --- / 
# -- / Player management

@onready var player_coordinate:Vector2 = Vector2(74,497)
@onready var zoomlevel:int = 1

func get_player_coord() -> Vector2: 
	return player_coordinate

func set_player_coord(new_coordinate:Vector2):
	player_coordinate = new_coordinate


func get_player_zoom() -> int: 
	return zoomlevel

func set_player_zoom(new_zoom:int):
	zoomlevel = new_zoom

# --- / 
# -- / Item / Inventory management 

@onready var item_inventory:Dictionary = Item.init_item_inventory()
#@onready var animal_inventory:Dictionary = Animal.init_animal_inventory()
# use belows definition whenever debugging states that require a specific animal inventory
@onready var animal_inventory:Dictionary = set_test_animal_inventory()


# retrieve inventory of items from singleton instance
func get_item_inventory() -> Dictionary:
	return item_inventory

# retrieve inventory of animals from singleton instance
func get_animal_inventory() -> Dictionary:
	return animal_inventory

# takes new item and updates amount stored in inventory 
# if ItemType is "None" nothing will be changed 
func add_to_inventory(new_item:Item.ItemType,quantity:int=1):
	if new_item != Item.ItemType.NONE:
		# we can verify that every item is constantly available!
		var selected_item = item_inventory[new_item]
		item_inventory[new_item] = selected_item + quantity
		#selected_item.increase_amount()
		# emit signal to update Ui
		updated_item_inventory.emit(item_inventory)

# takes new item inventory and replaces the internal item_inventory 
# may be used to load a saved inventory to the singleton ( save management )
func set_item_inventory(new_inventory:Dictionary):
	item_inventory = new_inventory
	print("setting loaded inventory")
	updated_item_inventory.emit(item_inventory)

# takes new animal inventory and replaces the internal animal_inventory
func set_animal_inventory(new_inventory:Dictionary):
	animal_inventory = new_inventory
	print("loaded animal inventory")
	updated_animal_inventory.emit(animal_inventory)

# emits a signal to update the ui with the stored inventories and quests
# may be used when entering the overworld and displaying available items
# helps to set the inventory in the ui
func signal_inventory_update_ui():
	updated_item_inventory.emit(item_inventory)
	updated_animal_inventory.emit(animal_inventory)
	updated_quest_list.emit(active_tracked_quests)
	

# checks whether requested item is contained 
# returns true if it is
# returns false otherwise
func request_item(requested_item:Item.ItemType) -> bool: 
	if item_inventory.has(requested_item):
		var item_instance:int = item_inventory[requested_item]
		
		if item_instance >= 1:
			return true
		
	return false

# reduce amount of item by one 
# ought to be preceeded by request_item()
# FIXME combine with request_item again
# this introduces calling request_item twice
# but makes sure to prevent wrong allocations or negative values 
func use_item(requested_item:Item.ItemType): 
	if request_item(requested_item):
		var queried_item = item_inventory[requested_item]
		item_inventory[requested_item] = queried_item -1

# --- / 
# -- / animal inventory


func add_to_animal_inventory(new_animal:Animal.AnimalType, quantity:int = 1): 
	if new_animal != Animal.AnimalType.NONE:
		# valid entry given 
		animal_inventory[new_animal] += quantity
		#selected_animal.increase_amount
		updated_animal_inventory.emit(animal_inventory)

# this method can be used to generate an animal inventory
# with custom amount of animals available. 
# used for debugging only
func set_test_animal_inventory() -> Dictionary:
	var inventory:Dictionary = Animal.init_animal_inventory()
	inventory[Animal.AnimalType.DEER] = 2
	inventory[Animal.AnimalType.SNAKE] = 3
	inventory[Animal.AnimalType.SQUIRREL] = 5
	inventory[Animal.AnimalType.SPIDER] = 3
	return inventory 


# --- / 
# -- / Overworld management 

# denotes amount of islands available
var TOTAL_ISLANDS:int = 2

# each entry resembles bridge_id
# this value is primary used for easier visualization of a map! 
# TODO actually one could just traverse the set of connected islands and then that should also be easier 
# true -> reachable somehow 
# false -> not reachable
var islands_reachable:Array[bool] 

# adjacency list denoting graph of islands and their edges ( bridges ) 
# TODO consider generating basd on amount of islands available

# TODO this seems like creating a lot of possible invariants 
# --> forgetting to add to both 0 : [...,1] and 1 : [...,m0]
@onready var bridges_built: Dictionary = {
# bridge_id : Array of connected island --> denotes edges of nodes
	0 : [0,1],	
	1 : [1,0],
	2 : [2],
	3 : [3],
	4 : [4]
}

# denotes the level to choose for each interaction!

@onready var bridge_level_scenes: Dictionary = {
	BridgeEdge.new(0,2): "res://bridges/scenes/Grid.tscn",
}

# queries dictionary of available bridge-level for requested level
# returns modified bridge-edge with path set if found 
# returns unchanged bridge-edge otherwise
func obtain_bridge_scene(requested_edge:BridgeEdge) -> BridgeEdge:
	for bridge_level:BridgeEdge in bridge_level_scenes:
		# traversing bridge_level scenes
		if (bridge_level.is_same_as(requested_edge)):
			# found match 
			var bridge_level_path:String = bridge_level_scenes[bridge_level]
			requested_edge.set_path(bridge_level_path)
	# returning the edge given  ( either with new path or without) 
	return requested_edge

# --- / 
# -- / NPC interaction management

# denotes quests that are actively tracked ( unresolved so far ) 
# gets filled with the string-representation of a quest!
# key -> npc_id | value -> String
var active_tracked_quests:Dictionary = {}

# takes id of npc and adds its quest to the list
# emits signal to update ui afterwards
# if npc does not have a quest, nothing changes
func add_quest_string(npc_id:int):
	# prevent collection of all quests to be listed 
	if npc_id == QUEST_TRACK_NPC_ID:
		return 
	var npc_object:NPC_interaction = obtain_npc_object(npc_id)
	var quest_id = npc_object.obtain_quest_id()
	if active_tracked_quests.has(quest_id):
		return
		# quest not found in dict yet
		# adding quest if it was not found already in dictionary
	if npc_object.has_quest():
		var stringified_quest:String = npc_object.stringify_quest()
		active_tracked_quests[quest_id] = stringified_quest
		updated_quest_list.emit(active_tracked_quests)

# takes id of npc and removes its entry in the list of quests
# only does so, if quest was resolved, changes nothing otherwise
func remove_quest_string(npc_id:int):
	var npc_object:NPC_interaction = obtain_npc_object(npc_id)
	var quest_id = npc_object.obtain_quest_id()
	if npc_object.check_quest_condition():
		# removing entry as it was resolved
		active_tracked_quests.erase(quest_id)
		updated_quest_list.emit(active_tracked_quests)

# denotes all NPCs available in current overworld 
# key ==> value ; npcid ==> NPC Object
var dictionary_npc:Dictionary = {} 

# we do have a special NPC that will  track all Quests available
# it ought to be denoted with a special id
var QUEST_TRACK_NPC_ID:int = 0

# adds npc object corresponding to its npc id 
func add_npc_instance(npc_id:int,npc_object:NPC_interaction):
	dictionary_npc[npc_id] = npc_object

# returns object of NPC_interaction linked to given id
func obtain_npc_object(npc_id) -> NPC_interaction:
	return dictionary_npc[npc_id]

# takes npc id, queries corresponding object 
# returns true if requirements for quest were met
# false otherwise
func obtain_npc_quest_state(npc_id) -> bool:
	var npc_object:NPC_interaction = obtain_npc_object(npc_id)
	#var quest_state:bool = npc_object.check_quest_condition()
	var quest_state:bool = npc_object.obtain_quest_state()
	#print("current state of quest" + str(quest_state))
	return quest_state

# queries all quests and their state
# returns dictionary with following structure
# key: quest-string -> value: state:Boolean
# FIXME could be its own datastructure!
func obtain_all_quest_states() -> Dictionary:
	var quest_states:Dictionary = {}
	for npc in dictionary_npc:
		# avoiding calling npc that calls this function
		# resolves possible recursion
		if npc == QUEST_TRACK_NPC_ID:
			continue
		var npc_object:NPC_interaction = dictionary_npc[npc]
		if npc_object.has_quest():
			var quest_string:String = npc_object.stringify_quest()
			var quest_state:bool = npc_object.check_quest_condition()
			quest_states[quest_string] = quest_state
	return quest_states

# --- / 
# -- / Bridge management 

# enum to indicate whether a path to a level is available
# or not
enum BridgeLevelPathState{
	AVAILABLE,
	NONE
}
# class denoting an edge in a graph 
# start_id denotes the node where the edge begins 
# dest_id denotes the node where the edge ends 
class BridgeEdge: 
	var start_id:int 
	var dest_id:int
	
	# used for deriving path to level denoted by this edge
	var path_state: BridgeLevelPathState = BridgeLevelPathState.NONE
	var path:String
	
	func _init(starting_id:int, destination_id:int):
		start_id = starting_id
		dest_id = destination_id
	
	# method to compare this edge with another given
	# returns true if they are equal, false otherwise
	# denote: edges are undirected so  (1,2) == (2,1)
	func is_same_as(other_edge:BridgeEdge) -> bool:
		var compared_start = other_edge.start_id
		var compared_end = other_edge.dest_id
		var comparison_start:bool = (start_id == compared_start) or ( compared_start == dest_id)  
		var comparison_dest:bool = (dest_id == compared_end) or (compared_end == start_id)
		if(comparison_start and comparison_dest):
			return true 
		return false
	
	# takes path as string and links it to this edge
	func set_path(new_path:String):
		path = new_path
		path_state = BridgeLevelPathState.AVAILABLE
	
	func set_availability(new_availability:BridgeLevelPathState):
		path_state = new_availability
	
	func get_path_state() -> BridgeLevelPathState:
		return path_state
# checks whether connection between two given values is possible or not
func check_bridge_connection(bridge_edge:BridgeEdge) -> bool: 
	var edge_start = bridge_edge.start_id 
	var edge_dest = bridge_edge.dest_id 
	if bridges_built[edge_start].has(edge_dest):
		return true 
	return false 

# adds new connection between starting point and ending point 
# adds this corresponding to representation 
func add_bridge_connection(bridge_edge:BridgeEdge):
	var edge_start = bridge_edge.start_id 
	var edge_dest = bridge_edge.dest_id 
	if not check_bridge_connection(bridge_edge): 
		# only met if no connection was set before
		# adding values to both becaus we are in an undirected graph
		bridges_built[edge_start].append(edge_dest)
		bridges_built[edge_dest].append(edge_start)


# --- / 
# -- / Save management

# takes String denoting used profile 
# loads and sets state from save 
func load_configuration(profile:String):
	pass

# saves the following scopes: overworld, bridge, profile 
func save_every_configuration():
	
	
	save_overworld_configuration()
	
	save_bridge_configuration()
	pass
	
# saves configuration from overworld 
# -> information linked to overworld interaction
func save_overworld_configuration():
	pass
	
# saves bridge configuration 
# -> information linked to bridge game 
func save_bridge_configuration():
	pass

# saves profile configuration
# -> information linked to profile
func save_profile_configuration():
	pass


# --- / 
# -- / Methods for NPC interaction 

# register here your dialogue, key is npc id 
@onready var npc_dialogues: Dictionary = {
	0 : QuestTrackNPC.new(),
	# FIXME Dummy until dialogues were iplemented 
	1 : ExampleData.new(),
	2 : ExampleData.new(),
	3 : ExampleData.new(),
	4 : ExampleData.new(),
}

@onready var dialogue: Dialogue = Dialogue.new()

# checks whether a npc has a dialogue linked to it
func has_dialogue(npc_id:int) -> bool:
	return npc_dialogues.has(npc_id)
	
# takes npc_id, enters the dialogue if one is linked to the current npc_id
func prepare_dialogue(npc_id:int):
	# FIXME this might be improved, as this is only useful for a single entity right now 
	if not has_dialogue(npc_id):
		print("WARNING: TRIED TO FIND AN NON EXISTING DIALOGUE FOR NPC", npc_id)
		return
	# updates dialogue for quest-tracking npc
	if npc_id == QUEST_TRACK_NPC_ID:
					## updating its state!
					var dialogue_object = obtain_dialogue(npc_id)
					var active_quests:Dictionary = active_tracked_quests
					dialogue_object.update_dialogue(active_quests)
	var data : Dialogue_Data = npc_dialogues[npc_id]
	dialogue.enter_dialogue(data, npc_id)

# returns whether the dialogue has been finished.
# finished is not just given by closing the dialogue window.
# a dialogue is finished, when the dialogue creator marks the dialogue 
# as finished in his code and on the page of his choose.
func check_dialogue_finished(npc_id:int) -> bool:
	if not has_dialogue(npc_id):
		return false
		
	return npc_dialogues[npc_id].finished

func obtain_dialogue(npc_id:int):
	return npc_dialogues[npc_id]

# returns true when the player is currently in dialogue
func navigation_in_dialogue() -> bool:
	return dialogue.in_dialogue()

# ends dialogue
func exit_dialogue():
	dialogue.exit_dialogue()



# --- / / 
# -- / Save management 
# - / / #FIXME requires several updates to store everything accordingly

# takes current state of player and returns it as dictionary
func save_player_state() -> Dictionary:
	var json_inventory = []
	var item_inventory = SingletonPlayer.item_inventory
	for item:Item.ItemType in item_inventory:
		var item_amount = item_inventory[item]
		var item_string:String = Item.item_type_to_string(item)
		var item_dictionary:Dictionary = {
			"type": item_string,
			"amount": item_amount
		}
		# store amount
		item_dictionary["amount"] = item_amount
		json_inventory.append(item_dictionary)

	var state = {
		"name" : "Player",
		"pos_x" : player_coordinate.x,
		"pos_y" : player_coordinate.y,
		"inventory": json_inventory,
		"zoom": SingletonPlayer.get_player_zoom()
	}
	return state

# wrapper for save config save-method
# FIXME
func save_game():
	Savemanager.save_config()
	
