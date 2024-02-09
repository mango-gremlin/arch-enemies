extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.volume_db = Settings.get_effects_volume()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_goal_area_2d_play_sound():
	playing = true
