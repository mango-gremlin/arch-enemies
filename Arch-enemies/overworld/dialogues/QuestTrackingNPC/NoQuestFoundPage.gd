extends Dialogue_Entry


class_name NoQuestFoundPage


# --- /
# -- / class constructor 
func _init():
	pass

func content() -> String:
	return "No quest found"

func image_src() -> String:
	return "res://overworld/dialogues/test_dialogue/red.png"
	
# null ement in array means here disable button X
func btn_text() -> Array[String]:
	return ["Exit", "", ""]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
	if btn == 0:
		SingletonPlayer.exit_dialogue()
