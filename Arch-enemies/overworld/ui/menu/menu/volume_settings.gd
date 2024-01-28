extends HSlider

enum SOUND_TYPE {MAIN, MUSIC, EFFECTS}

@export var current_sound_type:SOUND_TYPE

# Called when the node enters the scene tree for the first time.
func _ready():
	if current_sound_type == SOUND_TYPE.MAIN:
		self.value = Settings.main_volume * 100
	elif current_sound_type == SOUND_TYPE.MUSIC:
		self.value = Settings.music_volume * 100
	elif current_sound_type == SOUND_TYPE.EFFECTS:
		self.value = Settings.sound_volume * 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
