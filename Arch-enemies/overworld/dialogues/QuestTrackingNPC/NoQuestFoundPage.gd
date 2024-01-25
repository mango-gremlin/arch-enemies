extends Dialogue_Entry


class_name NoQuestFoundPage


# --- /
# -- / class constructor 
func _init():
	pass

func content() -> String:
	return "I will not join you >:( The others need to do something for once. Then maybe I will help."

func image_src() -> String:
	return "res://assets/art/characters/portraits/Portrait_Deer.png"
	
# null ement in array means here disable button X
func btn_text() -> Array[String]:
	return ["Exit", "", ""]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
	if btn == 0:
		SingletonPlayer.exit_dialogue()
