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

# string denoting what is shown upon interaction with bridge
@export var bridge_description: String


# could be a small preview of the level or whatever
@export var bridge_image:Image

# --- /
# -- / VISUALIZATION

# this enum denotes in which direction this bridge-Start is pointing. 
# this is necessary to take the corresponding sprite for visual representation! 
# left and right will use a vertical starting_sprite
# up and down will use a horizontal starting_sprite
enum bridgeSpriteDirection{
	LEFT,
	RIGHT,
	UP,
	DOWN,
}
@export var bridge_sprite_direction:bridgeSpriteDirection = bridgeSpriteDirection.LEFT

# takes bridge_sprite_direction and loads the corresponding sprite into this bridge-start
func load_bridge_direction_sprite(): 
	var referenced_sprite:TextureRect =  $bridge_start_sprite
	var path_to_texture:String
	match bridge_sprite_direction:
		bridgeSpriteDirection.LEFT: 
			path_to_texture = "res://assets/art/objects/overworld_bridges/overworld_bridge_start_vertical_unbuilt.png"
		bridgeSpriteDirection.RIGHT:
			path_to_texture = "res://assets/art/objects/overworld_bridges/overworld_bridge_start_vertical_unbuilt.png"
		bridgeSpriteDirection.UP:
			path_to_texture = "res://assets/art/objects/overworld_bridges/overworld_bridge_start_horizontal_unbuilt.png"
		bridgeSpriteDirection.DOWN:
			path_to_texture = "res://assets/art/objects/overworld_bridges/overworld_bridge_start_horizontal_unbuilt.png"
	# loading texture into rect
	var bridge_start_sprite = load(path_to_texture)
	referenced_sprite.texture = bridge_start_sprite

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
	
	# FIXME only use once / if approved 
	#load_bridge_direction_sprite()
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
func is_solved() -> bool:
	var connection_status:bool = SingletonPlayer.check_bridge_connection(bridge_edge)
	return connection_status
	
# changes appearance of bridge_node if it was solved 
# takes elements from "bridge_parts" and toggles their visibility
func visualize_status(): 
	if is_solved():
		var path_to_texture = "res://assets/art/bridge_dummy_success.png"
		var new_texture = load(path_to_texture)
		
		var referenced_rect:TextureRect = $bridge_start_sprite
		referenced_rect.texture = new_texture
		var referenced_bridge_parts = $bridge_parts
		referenced_bridge_parts.visible = true 
	else:
		# unsolved, hiding bridge_parts
		var referenced_bridge_parts = $bridge_parts
		referenced_bridge_parts.visible = false 

# sets collision of static_body attached 
func set_passability():
	# FIXME no perfect reference
	# however we are enforcing this structure with every bridge_interaction
	var referenced_bridge_shape:CollisionShape2D = $bridge_collision_shape/bridge_collision
	referenced_bridge_shape.disabled = is_solved()
	
	
	
