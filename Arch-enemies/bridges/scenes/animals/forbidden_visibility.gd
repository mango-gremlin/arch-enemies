extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(Color.AQUAMARINE, 0.7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.something_is_being_dragged:
		visible = true
	else:
		visible = false
