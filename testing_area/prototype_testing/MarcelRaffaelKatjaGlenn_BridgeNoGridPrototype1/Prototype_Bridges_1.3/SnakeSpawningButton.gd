extends Button

# The scene spawned by the button. Snek in this case
var new_animal = preload("res://snek.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed():
	var new_snake = new_animal.instantiate()
	self.get_parent().add_child(new_snake)
