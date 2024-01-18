extends AudioStreamPlayer2D
var squirrel = preload("res://assets/sound/Squirrel.wav")
var death = preload("res://assets/sound/Death.wav")
var deer = preload("res://assets/sound/Deer.wav")
var jump = preload("res://assets/sound/jump.wav")
var spider = preload("res://assets/sound/Spider.wav")
var step = preload("res://assets/sound/Step.wav")
var snake = preload("res://assets/sound/Snake.wav")
var victory = preload("res://assets/sound/Victory.wav")

func play_sound(sound):
	match sound:
		"DEATH":
			stream = death
			playing = true
		"DEER":
			stream = deer
			playing = true
		"JUMP":
			stream = jump
			playing = true
		"SNAKE":
			stream = snake
			playing = true
		"SPIDER":
			stream = spider
			playing = true
		"STEP":
			stream = step
			playing = true
		"SQUIRREL":
			stream = squirrel
			playing = true
		"VICTORY":
			stream = victory
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
