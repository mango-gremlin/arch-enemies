extends Control

var parent

var deer
var snake
var squirrel
var spider
var tutorial_level

signal play_sound(sound_type)

# Called when the node enters the scene tree for the first time.
func _ready():
	deer = get_node("Deer_Tutorial")
	snake = get_node("Snake_Tutorial")
	squirrel = get_node("Squirrel_Tutorial")
	spider = get_node("Spider_Tutorial")
	
	parent = get_parent()
	# different animal tutorials based on levels
	match parent.name:
		"TutorialLevel":
			tutorial_level = true
			change_visibilities(true,true,true,false)
		"FrogHazardLevel":
			tutorial_level = false
			change_visibilities(false,false,false,true)
		_:
			tutorial_level = false
			change_visibilities(true,true,true,true)


func _on_deer_button_pressed():
	deer.visible = false
	play_sound.emit("CLICK")
	is_all_closed()


func _on_snake_button_pressed():
	snake.visible = false
	play_sound.emit("CLICK")
	is_all_closed()


func _on_squirrel_button_pressed():
	squirrel.visible = false
	play_sound.emit("CLICK")
	is_all_closed()


func _on_spider_button_pressed():
	spider.visible = false
	play_sound.emit("CLICK")
	is_all_closed()


func _on_button_pressed():
	change_visibilities(true,true,true,true)
	# tutorial level cannot show spider
	if tutorial_level:
		spider.visible = false
	visible = false
	parent.get_node("Grid").visible = true
	play_sound.emit("CLICK")


func is_all_closed():
	if not (deer.visible or snake.visible or squirrel.visible or spider.visible):
		_on_button_pressed()


func change_visibilities(bool1, bool2, bool3, bool4):
	deer.visible = bool1
	snake.visible = bool2
	squirrel.visible = bool3
	spider.visible = bool4
