extends AudioStreamPlayer
#First we need to load all the sounds we intend to use
var squirrel = preload("res://assets/sound/Squirrel.wav")
var death = preload("res://assets/sound/Death.wav")
var drop = preload("res://assets/sound/Drop.wav")
var deer = preload("res://assets/sound/Deer.wav")
var jump = preload("res://assets/sound/Jump.wav")
var spider = preload("res://assets/sound/Spider.wav")
var snake = preload("res://assets/sound/Snake.wav")

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
	#Then we play it
	playing = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
