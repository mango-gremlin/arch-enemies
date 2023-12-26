extends Node
# SINGLETON REPRESENTATION 
#
# This file accumulates necessary functionality to:
# - represent the player within the woorld 
# - track progress of game 
# - user profiles 

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

@onready var item_inventory:Dictionary = Item.init_items()
# FIXME 
@onready var animal_inventory:Dictionary = {}


# takes new item and updates amount stored in inventory 
# if ItemType is "None" nothing will be changed 
func add_to_inventory(new_item:Item.ItemType):
	if new_item != Item.ItemType.NONE:
		# we can verify that every item is constantly available!
		var selected_item = item_inventory[new_item]
		selected_item.increase_amount()
		# emit signal to update Ui
		#updated_inventory.emit(inventory)
	# --> no item was received

func set_item_inventory(new_inventory:Dictionary):
	item_inventory = new_inventory

# checks whether requested item is contained 
# returns true if it was and decreases amount by one
# returns false otherwise
func request_item(requested_item:Item.ItemType) -> bool: 
	if item_inventory.has(requested_item):
		var item_instance:Item = item_inventory[requested_item]
		
		if item_instance.obtain_amount() >= 1:
			item_instance.set_amount(item_instance.obtain_amount() - 1)
			return true
		
	return false

func add_to_animal_inventory(new_animal:NPC_interaction.AnimalType): 
	if new_animal != NPC_interaction.AnimalType.NONE:
		# valid entry given 
		var selected_animal = animal_inventory[new_animal]
		selected_animal.increase_amount


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
}


# --- / 
# -- / NPC interaction management

enum AnimalType{
	SNAKE,
	DEER,
	SQUIRREL,
	SPIDER,
	NONE
	#FOX.
	# possibly more 
}

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

# --- / 
# -- / Bridge management 

# class denoting an edge in a graph 
# start_id denotes the node where the edge begins 
# dest_id denotes the node where the edge ends 
class BridgeEdge: 
	var start_id:int 
	var dest_id:int
	
	func _init(starting_id:int, destination_id:int):
		start_id = starting_id
		dest_id = destination_id
		

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
	
