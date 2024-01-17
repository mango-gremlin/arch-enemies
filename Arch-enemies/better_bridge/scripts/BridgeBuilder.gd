extends Node

class_name BridgeBuilder

#tile map we use to build the bridge
@export var map : BridgeMap
@export var tile_source_id : int = 0

@export var terrain_layer_index : int = 0
@export var legal_placement_layer_index : int = 1

@export var preview_color : Color =  Color.WHITE

#gets set in the _ready, for keeping track of the layer indecies
var placed_layer : int = -1
var preview_layer : int = -1

#for drag/preview
var is_dragging : bool = false
var current_preview_type : Animal.AnimalType = Animal.AnimalType.NONE
var last_preview_position : Vector2i = Vector2i.ZERO
var cam : Camera2D

#used for inventory display
@onready var animal_count = SingletonPlayer.get_animal_inventory().duplicate(true)
signal update_ui(type  : Animal.AnimalType, amount : int)

#for undo functionality
var undo_steps : Array[BridgeStep] = []

#static data for the animals, must be set in the code :/
var bridge_animals : Dictionary = {
	Animal.AnimalType.DEER : BridgeDeer.new(),
	Animal.AnimalType.SNAKE : BridgeSnake.new(),
	Animal.AnimalType.SPIDER : BridgeSpider.new(),
	Animal.AnimalType.SQUIRREL : BridgeSquirrel.new(),
}

#store the tileset id here! 
var tile_type_to_tile : Dictionary = {
	TileType.Variants.BODY : 9,
	TileType.Variants.HORIZONTAL : 5,
	TileType.Variants.VERTICAL : 6,
	TileType.Variants.FORBIDDEN : 8,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#needed for zoom while dragging
	cam = get_viewport().get_camera_2d()
	
	animal_count[Animal.AnimalType.DEER] = 3
	animal_count[Animal.AnimalType.SNAKE] = 3
	
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
	
	#disable the legal placement at the start
	map.set_layer_enabled(legal_placement_layer_index, false)

	#update the inventory ui
	for animal in animal_count:
		update_ui.emit(animal, animal_count[animal])
		
		
func _input(event):
	if not is_dragging:
		return
		
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false
			map.set_layer_enabled(preview_layer, false)
			map.set_layer_enabled(legal_placement_layer_index, false)
			
			_try_place_animal(current_preview_type, map.local_to_map(event.position / cam.zoom))
			return
	
	if event is InputEventMouseMotion:
		_preview_animal(current_preview_type, map.local_to_map(event.position / cam.zoom))
	
	
func _try_place_animal(type : Animal.AnimalType, pos : Vector2i):
	#get the data
	var animal = bridge_animals[type]
	
	var is_valid = false
	#let the animal decide if it wants to be placed lol
	if not animal.check_custom_placement_condition(pos, map, legal_placement_layer_index):
		return
	
	for body_cell in animal.body_cells:
		var body_pos = pos + body_cell
		
		#check for collision with the terrain
		var terrain_tile = map.get_tile_type(terrain_layer_index, body_pos)
		var legal_tile = map.get_tile_type(legal_placement_layer_index, body_pos)
		
		#check if we are allowed on the "terrain_tile"
		if not animal.is_valid_tile_type(terrain_tile):
			return
		
		if legal_tile != TileType.Variants.NONE:#check if we even have a tile
			if animal.is_valid_tile_type(legal_tile): #check if we can place here
				is_valid = true #set that we found, at least one tile
			else:
				return #we are not to place here!
			
	if is_valid:
		#ok we are allowed to place, now update the map
		_place_animal(type, pos)
		
		#and the placement map
		for body_cell in animal.body_cells:
			#place body tiles here
			map.set_cell(legal_placement_layer_index,pos + body_cell, tile_type_to_tile[TileType.Variants.BODY], Vector2i.ZERO)
		
		for attachment in animal.attach_cells:
			var attch_pos = pos + attachment.pos
			if (map.get_cell_source_id(terrain_layer_index, attch_pos) != -1 or 
				map.get_tile_type(legal_placement_layer_index, attch_pos) == TileType.Variants.BODY or 
				map.get_tile_type(legal_placement_layer_index, attch_pos) == TileType.Variants.FORBIDDEN): #if there is terrain, skip setting at this pos
				continue
				
			if attachment.tile_type == TileType.Variants.VERTICAL and map.get_tile_type(terrain_layer_index, attch_pos + Vector2i(0,1)) == TileType.Variants.TERRAIN:
				map.set_cell(legal_placement_layer_index,attch_pos, tile_type_to_tile[TileType.Variants.HORIZONTAL], Vector2i.ZERO)#we have ground below a vertical tile, so its horizontal
			else:
				map.set_cell(legal_placement_layer_index,attch_pos, tile_type_to_tile[attachment.tile_type], Vector2i.ZERO)

func _place_animal(type : Animal.AnimalType, pos : Vector2i):
	var animal = bridge_animals[type]
	var saved_cells : Array[BridgeCell] = []
	
	map.set_cell(placed_layer,pos,animal.source_id,Vector2i.ZERO)
		
	#set the inventory
	animal_count[type] -= 1
	update_ui.emit(type , animal_count[type])
	
	for body_cell in animal.body_cells:
		var _pos = pos + body_cell
		saved_cells.append(BridgeCell.new(_pos, map.get_tile_type(legal_placement_layer_index, _pos)))

	for attch_cell in animal.attach_cells:
		var _pos = pos + attch_cell.pos
		saved_cells.append(BridgeCell.new(_pos, map.get_tile_type(legal_placement_layer_index, _pos)))
	
	print(saved_cells)
	undo_steps.append(BridgeStep.new(type, pos, saved_cells))
	
func _undo_step():
	#check if something to undo
	if len(undo_steps) == 0:
		return
		
	var step : BridgeStep = undo_steps.pop_back()
	
	#add back to inventory
	animal_count[step.animal_type] += 1
	
	map.erase_cell(placed_layer, step.pos)

	for cell in step.prev_cells:
		if cell.tile_type in tile_type_to_tile: #check if we have a tile to place
			map.set_cell(legal_placement_layer_index, cell.pos, tile_type_to_tile[cell.tile_type],Vector2i.ZERO)
		else:
			map.erase_cell(legal_placement_layer_index, cell.pos) #just erase if not

func _preview_animal(type: Animal.AnimalType, pos : Vector2i):
	#erase at last pos, set at new pos
	map.erase_cell(preview_layer, last_preview_position)
	var brigde_animal : BrigdeAnimal = bridge_animals[type]
	map.set_cell(preview_layer,pos,brigde_animal.source_id,Vector2i.ZERO)
	last_preview_position = pos


func _set_preview_animal(type : Animal.AnimalType):
	#add inventory check here
	if animal_count[type] == 0:
		return
	
	#we can drag another animal
	is_dragging = true
	map.set_layer_enabled(preview_layer, true)
	map.set_layer_enabled(legal_placement_layer_index, true)
	map.clear_layer(preview_layer)
	current_preview_type = type
