extends Panel

@onready var window : Window = get_window()

func _ready():
	set_text("This a demo dialogue. Nothing to see here.")
	set_buttons(["Previous", "Next", "Exit"])
	set_image_texture("") # set default picture
	hide()
	
	SingletonPlayer.dialogue.npc_control_instance = self
	
# keep window on the buttom, does not working using canvas layers
func _process(delta):
	var window_size = window.size
	position.y = 0.0083102 * window_size.y + 426
	
	# print("WINDOW SIZE ", window_size.x, " ", window_size.y, " and y", position.y)

func set_text(body: String):
	$main_box/content_box/content/label_box/Label.text = body

func set_image_texture(src_path: String):
	if src_path == "":
		$main_box/image_box/Sprite2D.texture = load("res://assets/art/dialogue/green.png")
		return
		
	$main_box/image_box/Sprite2D.scale = Vector2(1.0, 1.0)	
	$main_box/image_box/Sprite2D.texture = load(src_path)
	
# null means disabled button, no fixme here xD
func set_buttons(txt: Array[String]):
	if len(txt) != 3:
		print("Current UI only supportes 3 buttons")
		return
		
	for btn_index in range(0, 3):
		var btn = get_node("main_box/content_box/buttons/Btn" + str(btn_index + 1))
		
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
