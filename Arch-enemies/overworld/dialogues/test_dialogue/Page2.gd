extends Dialogue_Entry


class_name Page2


# --- /
# -- / class constructor 
func _init():
	pass

func title() -> String:
	return "Seite 2"
	

func content() -> String:
	return "Ich hoffe sowas war geweunscht"
	
	
# null ement in array means here disable button X
func btn_text() -> Array[String]:
	return ["Back", "Weiter", "X"]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
	if btn == 0:
		SingletonPlayer.dialogue.select_page(0)	
		
	if btn == 1:
		SingletonPlayer.dialogue.select_page(2)
		
	if btn == 2:
		SingletonPlayer.exit_dialogue()
