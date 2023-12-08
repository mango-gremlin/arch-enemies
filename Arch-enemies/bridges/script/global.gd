extends Node

var drag_mode := true
var something_is_being_dragged := false
var currently_dragging


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
