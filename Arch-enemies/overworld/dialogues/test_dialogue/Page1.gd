extends Dialogue_Entry


class_name Page1

# --- /
# -- / class constructor 
func _init():
	pass

func content() -> String:
	return "This is the first page of the example dialogue. Navigate to the next page, by pressing the button"

func image_src() -> String:
	return "res://overworld/dialogues/test_dialogue/red.png"
	
# null ement in array means here disable button X
func btn_text() -> Array[String]:
	return ["I do nothing, consider disabling me?", "Next page", "Exit"]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
	if btn == 2:
		SingletonPlayer.exit_dialogue()
		
	if btn == 1:
		SingletonPlayer.dialogue.select_page(1)
