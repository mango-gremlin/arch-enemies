extends CheckButton


func _on_toggled(button_pressed):
	if not Global.drag_mode:
		Global.drag_mode = true
		self.text = "drag mode"
		print("drag mode activated")
	else:
		Global.drag_mode = false
		self.text = "fox   mode"
		print("drag mode deactivated")
