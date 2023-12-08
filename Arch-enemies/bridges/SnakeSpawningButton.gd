extends Button

# The scene spawned by the button. Snek in this case
var new_animal = preload("res://bridges/snek.tscn")

# creates a new instance of the snek class and adds it to the world.
func _on_pressed():
	var new_snake = new_animal.instantiate()
	new_snake.position = Vector2(192,142)
	self.get_parent().get_parent().add_child(new_snake)
