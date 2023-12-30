extends Dialogue_Entry


class_name Page3


# --- /
# -- / class constructor 
func _init():
	pass

func title() -> String:
	return "Seite 3"
	

func content() -> String:
	return "Mal gucken, nhhh"
	
	
# "" element in array means here disable button X
func btn_text() -> Array[String]:
	return ["Beenden", "", ""]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
	if btn == 0:
		SingletonPlayer.dialogue.finish_dialogue()
		SingletonPlayer.exit_dialogue()
