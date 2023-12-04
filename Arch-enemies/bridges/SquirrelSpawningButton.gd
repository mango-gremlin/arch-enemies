extends Button

# The scene spawned by the button. Squirrel in this case
var new_animal = preload("res://bridges/squirrel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# creates a new instance of the snek class and adds it to the world.
func _on_pressed():
	var new_squirrel = new_animal.instantiate()
	new_squirrel.position = Vector2(143,132)
	self.get_parent().get_parent().add_child(new_squirrel)
