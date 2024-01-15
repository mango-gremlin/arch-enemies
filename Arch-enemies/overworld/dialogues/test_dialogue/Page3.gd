extends Dialogue_Entry


class_name Page3



# --- /
# -- / class constructor 
func _init():
	pass

func content() -> String:
	return "And finally, the last page!"

func image_src() -> String:
	return "res://overworld/dialogues/test_dialogue/green.png"
		
	
# "" element in array means here disable button X
func btn_text() -> Array[String]:
	return ["Previous", "Exit", ""]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
	if btn == 0:
		SingletonPlayer.dialogue.select_page(1)
			
	if btn == 1:
		SingletonPlayer.dialogue.finish_dialogue()
		SingletonPlayer.exit_dialogue()
