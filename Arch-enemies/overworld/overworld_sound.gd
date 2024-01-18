extends AudioStreamPlayer2D
var squirrel = preload("res://assets/sound/Squirrel.wav")
var deer = preload("res://assets/sound/Deer.wav")
var spider = preload("res://assets/sound/Spider.wav")
var snake = preload("res://assets/sound/Snake.wav")

var step = preload("res://assets/sound/Step.wav")
var quest_accepted = preload("res://assets/sound/New_Quest.wav")
var quest_done = preload("res://assets/sound/Quest_Done.wav")

func play_sound(sound):
	match sound:
		"DEER":
			stream = deer
			playing = true
		"SNAKE":
			stream = snake
			playing = true
		"SPIDER":
			stream = spider
			playing = true
		"SQUIRREL":
			stream = squirrel
			playing = true
		"STEP":
			stream = step
			playing = true
		"QUEST_ACCEPTED":
			stream = quest_accepted
			playing = true
		"QUEST DONE":
			stream = quest_done
			playing = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO add connections here
