extends Node


#var is_dragging = false
var drag_mode = true
var something_is_being_dragged = false
var currently_dragging 

# returns animal type of StaticBody2D as string
# sadly required as I didn't find a function that returns all groups of given node
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
