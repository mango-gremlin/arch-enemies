extends Node

#var is_dragging = false
var drag_mode = true
var something_is_being_dragged = false
var currently_dragging 

func round_to_nearest(a:float, b:float):
	var grid_offset = fmod(a,b)
	if grid_offset < b / 2:
		return a - grid_offset
	else:
		return a + (b - grid_offset) 
