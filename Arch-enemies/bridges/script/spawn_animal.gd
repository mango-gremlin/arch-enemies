extends Button

@export var animal_scene : PackedScene

# creates a new instance of the current animal and adds it to the world.
func _on_pressed():
	var new_animal = animal_scene.instantiate()
	self.get_parent().get_parent().add_child(new_animal)
	# (self.size.x / 4) makes zero sense, but works. Button size seems to be doubled?
	new_animal.global_position.x = self.global_position.x + (self.size.x / 4)
	# simple offset is enough, as global position is on top of button
	# may edit for deer
	new_animal.global_position.y = self.global_position.y - 20
