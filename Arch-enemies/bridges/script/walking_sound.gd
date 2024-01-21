extends AudioStreamPlayer
#We need to use a timer to handle when to play the sound
@onready var timer:Timer = $"../Walking_Timer"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# check if the fox is walking as defined in the global script, play run sounds accordingly
func _process(delta):
	#Here we check when we play the sound. The Timer limits it to ever 0.18 sec with the sound being ~0.1 sec
	if timer.is_stopped():
		#If the timer has run through we check if the walking sound is supposed to be displayed
		if Global.walking:
			playing = true
		else:
			playing = false
		timer.start(0.18)
