extends Panel

@onready var window : Window = get_window()
@onready var text_box:Label = $main_box/content_box/content/label_box/Label
@onready var npc_name_label:Label = $main_box/content_box/npc_name
@onready var npc_sprite:Sprite2D = $main_box/image_box/Sprite2D

func _ready():
	set_text("This a demo dialogue. Nothing to see here.")
	set_buttons(["Previous", "Next", "Exit"])
	set_npc_name("display name here")
	set_image_texture("") # set default picture
	hide()
	
	SingletonPlayer.active_dialogue.npc_control_instance = self
	
# keep window on the buttom, does not working using canvas layers
func _process(delta):
	var window_size = window.size
	position.y = 0.0083102 * window_size.y + 426
	
	# print("WINDOW SIZE ", window_size.x, " ", window_size.y, " and y", position.y)

func set_text(body: String):
	text_box.text = body

func set_npc_name(npc_name:String):
	npc_name_label.text = npc_name

func set_image_texture(src_path: String):
	if src_path == "":
		# set default image to display
		npc_sprite.texture = load("res://assets/art/dialogue/green.png")
		return
	npc_sprite.scale = Vector2(2.2, 2.2)	
	npc_sprite.texture = load(src_path)
	
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
	SingletonPlayer.active_dialogue.btn_action(0)
	
	
func _on_btn_2_pressed():
	print("NPC INTERACTION BTN 2 PRESSED")
	SingletonPlayer.active_dialogue.btn_action(1)


func _on_btn_3_pressed():
	print("NPC INTERACTION BTN 3 PRESSED")
	SingletonPlayer.active_dialogue.btn_action(2)
