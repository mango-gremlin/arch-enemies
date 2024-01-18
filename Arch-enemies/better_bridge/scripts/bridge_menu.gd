extends Control

class_name BridgeMenu

func set_caption(caption : String):
	var label : Label= $HBoxContainer/TextureRect/VBoxContainer/Caption
	label.text = caption
	
func set_button_1(name : String, callable : Callable):
	var btn : BaseButton = $HBoxContainer/TextureRect/VBoxContainer/Button1 as BaseButton
	var label : Label = $HBoxContainer/TextureRect/VBoxContainer/Button1/Label
	
	label.text = name
	#be careful with multiple connections on the same button!
	for connection in btn.pressed.get_connections():
		btn.pressed.disconnect(connection["callable"])
		
	btn.pressed.connect(callable)

func set_button_2(name : String, callable : Callable):
	var btn : BaseButton = $HBoxContainer/TextureRect/VBoxContainer/Button2 as BaseButton
	var label : Label = $HBoxContainer/TextureRect/VBoxContainer/Button2/Label
	
	label.text = name
	
		#be careful with multiple connections on the same button!
	for connection in btn.pressed.get_connections():
		btn.pressed.disconnect(connection["callable"])
	btn.pressed.connect(callable)
