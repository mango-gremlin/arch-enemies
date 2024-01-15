extends Dialogue_Entry


class_name QuestTrackNPC_Page1


# --- /
# -- / class constructor 
func _init():
	pass

func content() -> String:
	var npc_object:NPC_interaction = SingletonPlayer.obtain_npc_object(0)
	var quest_list:String = npc_object.stringify_quest()
	return quest_list

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
