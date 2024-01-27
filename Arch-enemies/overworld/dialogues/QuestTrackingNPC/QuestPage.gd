extends Dialogue_Entry


class_name QuestPage

var quest: String
var current_page: int
var max_page: int

# --- /
# -- / class constructor 
func _init(_quest:String, _current_page:int, _max_page:int):
	quest = _quest
	#if _quest_solved:
		#quest = quest + "- solved"
	current_page = _current_page
	max_page = _max_page

func content() -> String:
	return quest

func image_src() -> String:
	return "res://assets/art/characters/portraits/Portrait_Deer.png"
	
# null ement in array means here disable button X
func btn_text() -> Array[String]:			
	return ["Previous", "Next", "Exit"]
	
func btn_states() -> Array[bool]:
	return [current_page <= 0, current_page >= max_page, false]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
	if btn == 0 and current_page > 0:
		SingletonPlayer.active_dialogue.select_page(current_page - 1)
	
	if btn == 1 and current_page < max_page:
		SingletonPlayer.active_dialogue.select_page(current_page + 1)
	
	if btn == 2:
		SingletonPlayer.exit_dialogue()
