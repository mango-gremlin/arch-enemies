extends AudioStreamPlayer
#First we need to load all the sounds we intend to use
var squirrel = preload("res://assets/sound/Squirrel.wav")
var deer = preload("res://assets/sound/Deer.wav")
var spider = preload("res://assets/sound/Spider.wav")
var snake = preload("res://assets/sound/Snake.wav")

var death = preload("res://assets/sound/Death.wav")
var drop = preload("res://assets/sound/Drop.wav")
var jump = preload("res://assets/sound/Jump.wav")
var click = preload("res://assets/sound/Button.wav")

var step = preload("res://assets/sound/Step.wav")
var quest_accepted = preload("res://assets/sound/New_Quest.wav")
var quest_done = preload("res://assets/sound/Quest_Done.wav")

func play_sound(sound:String) -> void:
	#Here we match the sound we are supposed to be playing
	match sound:
		"DEATH":
			stream = death
		"DEER":
			stream = deer
		"DROP":
			stream = drop
		"JUMP":
			stream = jump
		"SNAKE":
			stream = snake
		"SPIDER":
			stream = spider
		"SQUIRREL":
			stream = squirrel
		"QUEST_ACCEPTED":
			stream = quest_accepted
		"QUEST_DONE":
			stream = quest_done
	#Then we play it
	playing = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.volume_db = Settings.get_effects_volume()
	SingletonPlayer.play_sound.connect(play_sound)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_drag_grid_play_sound(sound):
	play_sound(sound)

func _on_deer_item_play_sound(sound):
	play_sound(sound)

func _on_snake_item_play_sound(sound):
	play_sound(sound)

func _on_spider_item_play_sound(sound):
	play_sound(sound)

func _on_squirrel_item_play_sound(sound):
	play_sound(sound)

func _on_player_play_sound(sound):
	play_sound(sound)

func _on_grid_play_sound(sound):
	play_sound(sound)


func _on_bridges_settings_menu_apply_volume():
	self.volume_db = Settings.get_effects_volume()
