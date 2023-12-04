extends Button

# The scene spawned by the button. Snek in this case
var new_animal = preload("res://spider.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# creates a new instance of the snek class and adds it to the world.
func _on_pressed():
	var new_spider = new_animal.instantiate()
	new_spider.position = Vector2(95,142)
	self.get_parent().get_parent().add_child(new_spider)
