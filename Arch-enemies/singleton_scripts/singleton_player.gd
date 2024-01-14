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
}


# --- / 
# -- / NPC interaction management

# denotes all NPCs available in current overworld 
# key ==> value ; npcid ==> NPC Object
var dictionary_npc:Dictionary = {
	
} 

# adds npc object corresponding to its npc id 
func add_npc_instance(npc_id:int,npc_object:NPC_interaction):
	dictionary_npc[npc_id] = npc_object

func obtain_npc_object(npc_id) -> NPC_interaction:
	return dictionary_npc[npc_id]
	

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
# register here your dialogue, key is npc id 
@onready var npc_dialogues: Dictionary = {1: ExampleData.new()}
@onready var dialogue: Dialogue = Dialogue.new()

# checks whether a npc has a dialogue linked to it
func has_dialogue(npc_id:int) -> bool:
	return npc_dialogues.has(npc_id)
	
# takes npc_id, enters the dialogue if one is linked to the current npc_id
func enter_dialogue(npc_id:int):
	if not has_dialogue(npc_id):
		print("WARNING: TRIED TO FIND AN NON EXISTING DIALOGUE FOR NPC", npc_id)
		return
	
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

# returns true when the player is currently in dialogue
func navigation_in_dialogue() -> bool:
	return dialogue.in_dialogue()

# ends dialogue
func exit_dialogue():
	dialogue.exit_dialogue()
	
