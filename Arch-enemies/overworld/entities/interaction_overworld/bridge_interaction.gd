extends Node2D

# --- / 
# -- / 
# -- | base properties for bridge instance
var interaction_type: Interactable.InteractionType = Interactable.InteractionType.BRIDGE
@export var bridge_reward:NPC_interaction.QuestReward

# denotes id of bridge-level this will be linked to
@export var start_island_id:int 
@export var dest_island_id:int 
# denotes 
var bridge_edge:SingletonPlayer.BridgeEdge

#@export var bridge_id:int

# string denoting what is shown upon interaction with bridge
@export var bridge_description: String


# could be a small preview of the level or whatever
@export var bridge_image:Image

# --- / 
# -- / further properties could be 
# - reward after completion 
# - // also denoted in #134 
# --> denote whether the bonus objective was achieved or not 


func _ready():
	var interactionspot_object = get_node("interactionspot")
	interactionspot_object.parent_node = self
	interactionspot_object.interact_type = interaction_type
	# constructing bridge edge 
	bridge_edge = SingletonPlayer.BridgeEdge.new(start_island_id,dest_island_id)
	
	set_passability()
	visualize_status()


## --- / 
## -- / INTERACTION WITH PLAYER 


# returns dialogue-String for displaying in dialogue-Box
# if item obtainable -> return item_dialogue_succes
# else -> return item_dialogue_failure
func obtain_description() -> String:
	return bridge_description

# returns both src and destination as dictionary 
# @returns dictionary where: 
# dictionary["start_island"] --> id of starting point 
# dictionary["dest_island -> id of destination point 
func obtain_bridge_edge() -> SingletonPlayer.BridgeEdge:
	return bridge_edge

# returns true if it was solved already 
# referenced in #137
func is_solved() -> bool:
	var connection_status:bool = SingletonPlayer.check_bridge_connection(bridge_edge)
	return connection_status
	
# changes appearance of bridge_node if it was solved 
# takes elements from "bridge_parts" and toggles their visibility
func visualize_status(): 
	if is_solved():
		var path_to_texture = "res://assets/art/bridge_dummy_success.png"
		var new_texture = load(path_to_texture)
		
		var referenced_rect:TextureRect = $TextureRect
		referenced_rect.texture = new_texture
		var referenced_bridge_parts = $bridge_parts
		referenced_bridge_parts.visible = true 

# sets collision of static_body attached 
func set_passability():
	# FIXME no perfect referecne 
	# however we are enforcing this structure with every bridge_interaction
	var referenced_bridge_shape:CollisionShape2D = $bridge_collision_shape/bridge_collision
	referenced_bridge_shape.disabled = is_solved()
	
	
	
