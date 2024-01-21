extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_deer_button_pressed():
	get_node("Deer_Tutorial").visible = false
	get_node("Snake_Tutorial").visible = true


func _on_snake_button_pressed():
	get_node("Snake_Tutorial").visible = false
	get_node("Squirrel_Tutorial").visible = true


func _on_squirrel_button_pressed():
	get_node("Squirrel_Tutorial").visible = false
	get_node("Spider_Tutorial").visible = true


func _on_spider_button_pressed():
	get_node("Spider_Tutorial").visible = false
	visible = false


func _on_button_pressed():
	visible = false
