extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_retry_button_pressed():
	get_parent().get_node("fox").reset_fox()
	visible = false


func _on_continue_button_pressed():
	print("lets go to the overworld now")
	
