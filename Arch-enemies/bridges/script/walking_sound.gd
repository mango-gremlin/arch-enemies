extends AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"../Walking_Timer".is_stopped():
		if Global.walking:
			playing = true
			$"../Walking_Timer".start(0.18)
		else:
			playing = false
			$"../Walking_Timer".start(0.18)
