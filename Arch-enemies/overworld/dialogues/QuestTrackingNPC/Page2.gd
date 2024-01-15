extends Dialogue_Entry


class_name QuestTrackNPC_Page2



# --- /
# -- / class constructor 
func _init():
	pass	

func content() -> String:
	return "I'm the second page of the dialogue!"

func image_src() -> String:
	return "res://overworld/dialogues/test_dialogue/blue.png"
	
# null ement in array means here disable button X
func btn_text() -> Array[String]:
	return ["Previous","Exit"]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
	if btn == 0:
		SingletonPlayer.dialogue.select_page(0)	
	if btn == 2:
		SingletonPlayer.exit_dialogue()
