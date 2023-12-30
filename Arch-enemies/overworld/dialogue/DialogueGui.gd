extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	set_text("Hello", "World!")
	set_buttons(["I", "hate", "Godot"])
	hide()
	
	SingletonPlayer.dialogue.npc_control_instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_text(headline: String, body: String):
	$row/name.text = headline
	$row/content.text = body
	
	
# null means disabled button, no fixme here xD
func set_buttons(txt: Array[String]):
	if len(txt) != 3:
		print("Current UI only supportes 3 buttons")
		return
		
	for btn_index in range(0, 3):
		var btn = get_node("row/buttons/Btn" + str(btn_index + 1))
		
		if btn == null:
			print("BUTTON IS null???")
		
		if txt[btn_index] != "":
			btn.text = txt[btn_index]
			btn.show()
		else:
			btn.hide()
			

func _on_btn_1_pressed():
	print("NPC INTERACTION BTN 1 PRESSED")
	SingletonPlayer.dialogue.btn_action(0)
	
	
func _on_btn_2_pressed():
	print("NPC INTERACTION BTN 2 PRESSED")
	SingletonPlayer.dialogue.btn_action(1)


func _on_btn_3_pressed():
	print("NPC INTERACTION BTN 3 PRESSED")
	SingletonPlayer.dialogue.btn_action(2)
