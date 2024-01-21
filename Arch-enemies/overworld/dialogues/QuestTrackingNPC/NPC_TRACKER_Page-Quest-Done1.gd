extends Dialogue_Entry


class_name NPC_TRACKER_PageQuestDone1



# --- /
# -- / class constructor 
func _init():
	pass

func content() -> String:
	return "Finally, someone other than me does anything around here... I guess I can join."

func image_src() -> String:
	return "res://assets/art/characters/portraits/Portrait_Deer.png"
		
	
# "" element in array means here disable button X
func btn_text() -> Array[String]:
	return ["exit", "", ""]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
			
	if btn == 0:
		print("executing button action")
		SingletonPlayer.dialogue.finish_dialogue()
		SingletonPlayer.exit_dialogue()
