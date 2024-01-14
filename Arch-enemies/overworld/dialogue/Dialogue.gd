# class: Dialogue
# --- / 
# Main handler for npc dialogues in the overworld
class_name Dialogue

var is_in_dialogue:bool = false 
var active_dialogue:Dialogue_Data = null
var current_npc_id : int = 0

# no type here, on startup, this will be configured
var npc_control_instance = null

# --- /
# -- / class constructor 
func _init():
	pass

func enter_dialogue(dialogue:Dialogue_Data, npc_id: int):
	current_npc_id = npc_id
	is_in_dialogue = true 
	active_dialogue = dialogue
	
	active_dialogue.select_page(0)

func in_dialogue() -> bool:
	return is_in_dialogue

func exit_dialogue():
	is_in_dialogue = false 
	active_dialogue = null
	
	# hide panel
	npc_control_instance.hide()

func select_page(page: int):
	if active_dialogue == null:
		print("NO DIALOGUE STARTED, CAN'T CHANGE PAGE")
		return
		
	active_dialogue.select_page(page)
	
func btn_action(btn: int):
	if active_dialogue == null:
		return
	
	active_dialogue.btn_action(btn)
	

# THIS METHOD CHANGES THE DIALOGUE_DATA, SETS IT TO FINISHED, AS A CONSEQUENCE, IN THE NPC ITSELF, THE OBJECT IS GONNA CHANGE,
# THIS WAY, YOU FIND OUT, WHICH DIALOGUE IS COMPLETED
# FINISH_DIALOGUE ITSELF MUST BE CALLED FROM INSIDE A CONCRETE DIALOGUE
func finish_dialogue():
	if active_dialogue == null:
		print("NO DIALOGUE TO FINISH")
		return
	
	print("DIALOGUE FINISHED")
	
	active_dialogue.finished = true
