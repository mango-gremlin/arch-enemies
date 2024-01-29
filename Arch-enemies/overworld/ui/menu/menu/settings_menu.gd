extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# return to pause menu
func _on_return_pressed():
	get_tree().change_scene_to_file("res://overworld/ui/menu/menu/pause_menu.tscn")

# save current values
func _on_apply_pressed() -> void:
	Settings.main_volume =  $"VBoxContainer/MainVolume".value / 100
	Settings.music_volume = $"VBoxContainer/MusicVolume".value / 100
	Settings.effects_volume = $"VBoxContainer/EffectsVolume".value / 100
	BackgroundMusic.volume_db = Settings.get_music_volume()
