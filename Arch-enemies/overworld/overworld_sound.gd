extends AudioStreamPlayer
var squirrel = preload("res://assets/sound/Squirrel.wav")
var deer = preload("res://assets/sound/Deer.wav")
var spider = preload("res://assets/sound/Spider.wav")
var snake = preload("res://assets/sound/Snake.wav")

var step = preload("res://assets/sound/Step.wav")
var quest_accepted = preload("res://assets/sound/New_Quest.wav")
var quest_done = preload("res://assets/sound/Quest_Done.wav")

func _ready():
	SingletonPlayer.play_sound.connect(play_sound)

func play_sound(sound:String) -> void:
	print("entered play sound ", sound, " for overworld")
	match sound:
		"DEER":
			stream = deer
		"SNAKE":
			stream = snake
		"SPIDER":
			stream = spider
		"SQUIRREL":
			stream = squirrel
		"STEP":
			stream = step
		"QUEST_ACCEPTED":
			stream = quest_accepted
		"QUEST_DONE":
			stream = quest_done
	playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
