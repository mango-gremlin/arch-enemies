extends CheckButton

func _on_toggled(toggled_on):
	if not Global.drag_mode:
		Global.drag_mode = true
		self.text = "drag mode"
	else:
		Global.drag_mode = false
		self.text = "fox mode"
