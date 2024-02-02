extends Control

signal open_settings
signal play_sound(sound_type)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_overworld_pressed():
	# Set drag mode to true for other levels (should really be refactored)
	Global.drag_mode = true
	# TODO improve  by constantly saving the previous scene in a variable!
	play_sound.emit("CLICK")
	get_tree().change_scene_to_file("res://overworld/main_scene_overworld.tscn")

func _on_exit_pressed():
	# exit game
	#SingletonPlayer.save_game()
	play_sound.emit("CLICK")
	get_tree().quit()

# only for overworld / main menu
func _on_options_pressed():
	play_sound.emit("CLICK")
	get_tree().change_scene_to_file("res://overworld/ui/menu/menu/settings_menu.tscn")

# only for bridges
func _on_bridges_options_pressed():
	self.visible = false
	open_settings.emit()
	play_sound.emit("CLICK")
