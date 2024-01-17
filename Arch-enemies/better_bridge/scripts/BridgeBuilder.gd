extends Node

class_name BridgeBuilder

#tile map we use to build the bridge
@export var map : TileMap
@export var tile_source_id : int = 0

@export var terrain_layer_index : int = 0
@export var legal_placement_layer_index : int = 1

@export var preview_color : Color =  Color.WHITE

var placed_layer : int = -1
var preview_layer : int = -1

#for drag/preview
var is_dragging : bool = false
var current_preview_type : Animal.AnimalType = Animal.AnimalType.NONE
var last_preview_position : Vector2i = Vector2i.ZERO

#static data for the animals, must be set in the code :/
var animal_dict : Dictionary = {
	Animal.AnimalType.DEER : BridgeDeer.new(),
	Animal.AnimalType.SNAKE : BridgeSnake.new(),
	Animal.AnimalType.SPIDER : BridgeSpider.new(),
	Animal.AnimalType.SQUIRREL : BridgeSquirrel.new(),
}

enum TILE_TYPE{
	TERRAIN,       #0
	DEEP_WATER,    #1
	BODY,          #2
	FORBIDDEN,     #3
	SHALLOW_WATER, #4        
	HORIZONTAL,    #5
	VERTICAL,      #6
	NONE,
}


# Called when the node enters the scene tree for the first time.
func _ready():
	if map.get_layers_count() >= 2:
		printerr("There might be a collision with layers in the current map")
		
	#create needed layers
	map.add_layer(-1) #Placed Animals
	map.set_layer_name(-1, "PLACED")
	map.set_layer_enabled(-1, true)
	placed_layer = map.get_layers_count() - 1 #save the index
	
	map.add_layer(-1) #Preview
	map.set_layer_name(-1, "DRAGPREVIEW")
	map.set_layer_modulate(-1, preview_color)
	map.set_layer_enabled(-1, true)
	preview_layer = map.get_layers_count() - 1 #save the index


func _input(event):
	if not is_dragging:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false
			map.set_layer_enabled(preview_layer, false)
			map.set_layer_enabled(legal_placement_layer_index, false)
			
			_try_place_animal(animal_dict[current_preview_type], map.local_to_map(event.position))
			return
	
	if event is InputEventMouseMotion:
		_preview_animal(current_preview_type, map.local_to_map(event.position))
	
	
func _try_place_animal(animal : BrigdeAnimal, pos : Vector2i):
	var is_valid = false
	for body_cell in animal.body_cells:
		var body_pos = pos + body_cell
		
		#check for collision with the terrain
		if map.get_cell_source_id(terrain_layer_index, body_pos) != -1:
			print("Collided with Terrain")
			return
		
		if map.get_cell_source_id(legal_placement_layer_index, body_pos) != -1: #check if there is a cell
			var tile_type = map.get_cell_tile_data(legal_placement_layer_index,body_pos).get_custom_data("PLACEMENT_MASK") as BridgeBuilder.TILE_TYPE
			if animal.is_valid_tile_type(tile_type): #check if we can place here
				is_valid = true #set that we found, at least one tile
			else:
				return #we are not to place here!
				
	if is_valid:
		#ok we are allowed to place, now update the map
		map.set_cell(placed_layer,pos,animal.source_id,Vector2i.ZERO)
		
		#and the placement map
		for body_cell in animal.body_cells:
			map.erase_cell(legal_placement_layer_index,pos + body_cell)
			#place body tiles here
		
		for attachment in animal.attach_cells:
			var attch_pos = pos + attachment.offset
			if map.get_cell_source_id(terrain_layer_index, attch_pos) != -1: #if there is terrain, skip setting at this pos
				continue
			map.set_cell(legal_placement_layer_index,attch_pos,5, Vector2i.ZERO)

func _preview_animal(type: Animal.AnimalType, pos : Vector2i):
	map.erase_cell(preview_layer, last_preview_position)
	var brigde_animal : BrigdeAnimal = animal_dict[type]
	map.set_cell(preview_layer,pos,brigde_animal.source_id,Vector2i.ZERO)
	last_preview_position = pos


func _set_preview_animal(type : Animal.AnimalType):
	#add inventory check here
	is_dragging = true
	map.set_layer_enabled(preview_layer, true)
	map.set_layer_enabled(legal_placement_layer_index, true)
	map.clear_layer(preview_layer)
	current_preview_type = type
