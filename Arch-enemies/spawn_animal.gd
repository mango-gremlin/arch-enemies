extends Button

@export var animal_scene : StaticBody2D

# The scene spawned by the button. Snek in this case
var new_animal = preload("res://bridges/spider.tscn")


# creates a new instance of the snek class and adds it to the world.
func _on_pressed():
	var new_spider = new_animal.instantiate()
	new_spider.position = Vector2(95,142)
	self.get_parent().get_parent().add_child(new_spider)
