extends Node

# the volume of sounds, should be a value between 0 and 1
var main_volume:float
var music_volume:float
var effects_volume:float

# default values for sound volume, in case you want to reset them
# CURRENTLY NOT IN USE!
var default_main_volume:float = 0.5
var default_music_volume:float = 0.5
var default_effects_volume:float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_sound()

func reset_sound() -> void:
	self.main_volume = default_main_volume
	self.music_volume = default_music_volume
	self.effects_volume = default_effects_volume

func get_music_volume() -> float:
	return linear_to_db(main_volume * music_volume)

func get_effects_volume() -> float:
	return linear_to_db(main_volume * effects_volume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
