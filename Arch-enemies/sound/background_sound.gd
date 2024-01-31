extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.volume_db = Settings.get_music_volume()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
