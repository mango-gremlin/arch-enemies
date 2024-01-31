extends Control

signal apply_volume()
signal play_sound(sound_type)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# return to pause menu
func _on_return_pressed():
	play_sound.emit("CLICK")
	get_tree().change_scene_to_file("res://overworld/ui/main_menu/main_menu.tscn")

# save current values
func _on_apply_pressed() -> void:
	Settings.main_volume =  $"VBoxContainer/MainVolume".value
	Settings.music_volume = $"VBoxContainer/MusicVolume".value
	Settings.effects_volume = $"VBoxContainer/EffectsVolume".value
	BackgroundMusic.volume_db = Settings.get_music_volume()
	apply_volume.emit()
	play_sound.emit("CLICK")

func _on_bridges_pause_menu_open_settings():
	self.visible = true
