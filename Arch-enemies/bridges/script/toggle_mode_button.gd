extends CheckButton


func _on_toggled(_button_pressed):
	if not Global.drag_mode:
		Global.drag_mode = true
		self.text = "drag mode"
	else:
		Global.drag_mode = false
		self.text = "fox mode"
