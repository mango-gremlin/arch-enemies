extends AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# check if the fox is walking as defined in the global script, play run sounds accordingly
func _process(delta):
	var timer:Timer = $"../Walking_Timer"
	if timer.is_stopped():
		if Global.walking:
			playing = true
		else:
			playing = false
		timer.start(0.18)
