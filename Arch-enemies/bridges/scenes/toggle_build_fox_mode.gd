extends CheckButton

func _on_toggled(toggled_on):
	var grid = get_parent().get_parent()
	if not Global.drag_mode:
		Global.drag_mode = true
		self.text = "Drag Mode"
		grid.find_child("Reset").visible = true
		grid.find_child("Last_State").visible = true
	else:
		Global.drag_mode = false
		self.text = "Fox Mode"
		grid.find_child("Reset").visible = false
		grid.find_child("Last_State").visible = false
