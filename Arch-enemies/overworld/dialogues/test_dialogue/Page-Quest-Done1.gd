extends Dialogue_Entry


class_name PageQuestDone



# --- /
# -- / class constructor 
func _init():
	pass

func content() -> String:
	return "Alt text for solved quest"

func image_src() -> String:
	return "res://overworld/dialogues/test_dialogue/green.png"
		
	
# "" element in array means here disable button X
func btn_text() -> Array[String]:
	return ["exit", "", ""]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
			
	if btn == 0:
		print("executing button action")
		SingletonPlayer.dialogue.finish_dialogue()
		SingletonPlayer.exit_dialogue()
