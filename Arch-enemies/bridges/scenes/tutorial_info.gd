extends Control

var parent

var deer
var snake
var squirrel
var spider
var goal
var zones
var buttons
var hazards
var tutorial_level

signal play_sound(sound_type)

# Called when the node enters the scene tree for the first time.
func _ready():
	deer = get_node("Deer_Tutorial")
	snake = get_node("Snake_Tutorial")
	squirrel = get_node("Squirrel_Tutorial")
	spider = get_node("Spider_Tutorial")
	goal = get_node("Goal_Tutorial")
	zones = get_node("Zones_Tutorial")
	buttons = get_node("Buttons_Tutorial")
	hazards = get_node("Hazards_Tutorial")
	
	parent = get_parent()
	self.visible = true
	parent.get_node("Grid").visible = false
	# different animal tutorials based on levels
	match parent.name:
		"TutorialLevel":
			tutorial_level = true
			change_visibilities(true,true,true,true,true,false,true,true)
		_:
			tutorial_level = false
			change_visibilities(false,false,false,false,false,true,false,false)



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
	change_visibilities(true,true,true,true,true,true,true,true)
	# tutorial level cannot show spider
	if tutorial_level:
		spider.visible = false
	visible = false
	parent.get_node("Grid").visible = true
	play_sound.emit("CLICK")


func is_all_closed():
	if not (deer.visible or snake.visible or squirrel.visible or spider.visible or goal.visible or zones.visible or buttons.visible or hazards.visible):
		_on_button_pressed()


func change_visibilities(goal_bool, zones_bool, deer_bool, snake_bool, squirrel_bool, spider_bool, button_bool, hazards_bool):
	goal.visible = goal_bool
	zones.visible = zones_bool
	deer.visible = deer_bool
	snake.visible = snake_bool
	squirrel.visible = squirrel_bool
	spider.visible = spider_bool
	buttons.visible = button_bool
	hazards.visible = hazards_bool


func _on_goal_button_pressed():
	goal.visible = false
	play_sound.emit("CLICK")
	is_all_closed()


func _on_zones_button_pressed():
	zones.visible = false
	play_sound.emit("CLICK")
	is_all_closed()


func _on_buttons_button_pressed():
	buttons.visible = false
	play_sound.emit("CLICK")
	is_all_closed()


func _on_hazards_button_pressed():
	hazards.visible = false
	play_sound.emit("CLICK")
	is_all_closed()
