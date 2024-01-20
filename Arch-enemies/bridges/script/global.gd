extends Node

var drag_mode := true
var something_is_being_dragged := false
var currently_dragging
var menu_mode := false
var goal_reached := false

# round to nearest multiple of grid_size
func round_to_nearest(position:float, grid_size:float):
	var offset = fmod(position, grid_size)
	if offset < grid_size / 2:
		return position - offset
	else:
		return position + (grid_size - offset) 


# returns animal type of StaticBody2D as string
func get_animal_type(body:StaticBody2D):
	if body.is_in_group("snake"):
		return "snake"
	elif body.is_in_group("squirrel"):
		return "squirrel"
	elif body.is_in_group("deer"):
		return "deer"
	elif body.is_in_group("spider"):
		return "spider"
	return ""

# change the visibility of all ui elements in bridge scene
func change_ui_visibility(visibility:bool, grid:Node):
	grid.find_child("Drag_or_Fox").visible = visibility
	grid.find_child("Reset").visible = visibility
	grid.find_child("Last_State").visible = visibility
	grid.find_child("Animal_Inventory").visible = visibility
	grid.find_child("animal_inventory_counter").visible = visibility
	grid.find_child("Player").visible = visibility

# reset menu,drag and goal variables
func reset_modes():
	drag_mode = true
	menu_mode = false
	goal_reached = false
