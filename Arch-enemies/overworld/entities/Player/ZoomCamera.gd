extends Camera2D

@export var MIN_ZOOM : float = 3
@export var MAX_ZOOM : float = 15

@export var ZOOM_SPEED : float = 1
@export var ZOOM_DURATION : float = 0.2

var player_object = null
var current_zoom = 1 

func _set_current_zoom(value: float, store: bool = false):
	var tween = create_tween()
	current_zoom = clamp(value, MIN_ZOOM, MAX_ZOOM)
	
	if store:
		if player_object != null:
			player_object.savePlayer()
		else:
			print("Storing zoom change in Camera2D failed!")
	
	tween.tween_property(self, "zoom", Vector2(current_zoom, current_zoom), ZOOM_DURATION).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR).from_current()
	

func _input(event):
	if event.is_action_pressed("zoom_in"):
		_set_current_zoom(current_zoom - ZOOM_SPEED)
	if event.is_action_pressed("zoom_out"):
		_set_current_zoom(current_zoom + ZOOM_SPEED)
