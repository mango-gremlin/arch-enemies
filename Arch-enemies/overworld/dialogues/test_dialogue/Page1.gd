extends Dialogue_Entry


class_name Page1

# --- /
# -- / class constructor 
func _init():
	pass
	
func title() -> String:
	return "Seite 1"
	

func content() -> String:
	return "Hallo Welt"
	
	
# null ement in array means here disable button X
func btn_text() -> Array[String]:
	return ["Back", "Weiter", "X"]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
	if btn == 2:
		SingletonPlayer.exit_dialogue()
		
	if btn == 1:
		SingletonPlayer.dialogue.select_page(1)
