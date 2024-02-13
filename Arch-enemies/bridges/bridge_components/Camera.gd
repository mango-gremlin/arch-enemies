extends Camera2D
signal send_zoom(zoom)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_grid_get_zoom():
	#Essentially we just use this script to dynamically send the zoom
	#We are using a script of it's own in case we want camera movements or other similar things
	send_zoom.emit(zoom)
