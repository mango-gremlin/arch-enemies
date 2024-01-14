extends Node
# SINGLETON REPRESENTATION 
#
# This file accumulates necessary functionality to:
# - represent the player within the woorld 
# - track progress of game 
# - user profiles 

# -- Signals 
signal updated_item_inventory(new_inventory)
signal updated_animal_inventory(new_animal_inventory)
signal updated_quest_list(new_quest_list)

# --- / 
# -- / Player management

@onready var player_coordinate:Vector2 = Vector2.ZERO
@onready var zoomlevel:Vector2 = Vector2(1,1)

func get_player_coord() -> Vector2: 
	return player_coordinate

func set_player_coord(new_coordinate:Vector2):
	player_coordinate = new_coordinate


func get_player_zoom() -> Vector2: 
	return zoomlevel

# --- / 
# -- / Item / Inventory management 

@onready var item_inventory:Dictionary = Item.init_item_inventory()
@onready var animal_inventory:Dictionary = Animal.init_animal_inventory()

# retrieve inventory of items from singleton instance
func get_item_inventory() -> Dictionary:
	return item_inventory

# retrieve inventory of animals from singleton instance
func get_animal_inventory() -> Dictionary:
	return animal_inventory

# takes new item and updates amount stored in inventory 
# if ItemType is "None" nothing will be changed 
func add_to_inventory(new_item:Item.ItemType):
	if new_item != Item.ItemType.NONE:
		# we can verify that every item is constantly available!
		var selected_item = item_inventory[new_item]
		item_inventory[new_item] = selected_item + 1 
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

func add_to_animal_inventory(new_animal:Animal.AnimalType): 
	if new_animal != Animal.AnimalType.NONE:
		# valid entry given 
		animal_inventory[new_animal] += 1
		#selected_animal.increase_amount
		updated_animal_inventory.emit(animal_inventory)


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
	3 : [3]
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
var quest_string_dict:Dictionary = {}

# takes id of npc and adds its quest to the list
# emits signal to update ui afterwards
# if npc does not have a quest, nothing changes
func add_quest_string(npc_id:int):
	var npc_object:NPC_interaction = obtain_npc_object(npc_id)
	var quest_id = npc_object.obtain_quest_id()
	if quest_string_dict.has(quest_id):
		return
		# quest not found in dict yet
		# adding quest if it was not found already in dictionary
	if npc_object.has_quest():
		var stringified_quest:String = npc_object.stringify_quest()
		quest_string_dict[quest_id] = stringified_quest
		updated_quest_list.emit(quest_string_dict)

# takes id of npc and removes its entry in the list of quests
# only does so, if quest was resolved, changes nothing otherwise
func remove_quest_string(npc_id:int):
	var npc_object:NPC_interaction = obtain_npc_object(npc_id)
	var quest_id = npc_object.obtain_quest_id()
	if npc_object.check_quest_condition():
		# removing entry as it was resolved
		quest_string_dict.erase(quest_id)
		updated_quest_list.emit(quest_string_dict)

# denotes all NPCs available in current overworld 
# key ==> value ; npcid ==> NPC Object
var dictionary_npc:Dictionary = {} 

# adds npc object corresponding to its npc id 
func add_npc_instance(npc_id:int,npc_object:NPC_interaction):
	dictionary_npc[npc_id] = npc_object

func obtain_npc_object(npc_id) -> NPC_interaction:
	return dictionary_npc[npc_id]


var is_in_dialogue:bool = false 
# may be improved 
var active_dialogue:int = 0
var test:Array

# Dictionary of NPC's that have been talked to
# -> key: integer : denoting npc_id
# -> value: bool : denoting whether interaction was done or not 
# FIXME might lead to wrong interpretation ? 
var npc_talked_to: Array = [0]

# checks whether player already interacted with npc 
func check_npc_state(npc_id:int) -> bool: 
	if npc_talked_to.has(npc_id):
		return true 
	return false 

# takes npc Id and adds it to array of npcs talked to 
# does not change if it was contained already
# adds / removes quest of npc as well 
# FIXME maybe refactor 
func add_npc_talked_to(npc_id:int):
	if npc_talked_to.has(npc_id):
		remove_quest_string(npc_id)
		return 
	# adding to array
	npc_talked_to.append(npc_id)
	# also contains logic for adding quest ! 
	add_quest_string(npc_id)
	

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

# takes npc_id, sets is_in_dialogue to true, 
# queries dialogue to display from given id
# TODO handle dialogue and query dialogue from given npc_id
func enter_dialogue(npc_id:int):
	

	is_in_dialogue = true 
	active_dialogue = npc_id

	pass

# ends dialogue -> sets is_in_dialogue to false 
func exit_dialogue():
	is_in_dialogue = false 
	active_dialogue = 0
	
