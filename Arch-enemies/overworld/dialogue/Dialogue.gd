# class: Dialogue
# --- / 
# Main handler for npc dialogues in the overworld
class_name Dialogue

var is_in_dialogue:bool = false 
var active_dialogue:Dialogue_Data = null
var current_npc_id : int = 0

# no type here, on startup, this will be configured
# FIXME declare type
var npc_control_instance = null

# --- /
# -- / class constructor 
func _init():
	pass

func enter_dialogue(dialogue:Dialogue_Data, npc_id: int):
	current_npc_id = npc_id
	is_in_dialogue = true 
	active_dialogue = dialogue
	# adding quest to players UI
	SingletonPlayer.add_quest_string(npc_id)
	print("current npc id:" + str(npc_id))
	var quest_state:bool = SingletonPlayer.obtain_npc_quest_state(npc_id)
	var dialogue_state:bool = SingletonPlayer.check_dialogue_finished(current_npc_id)
	print(dialogue_state)
	if (quest_state and dialogue_state):
		# was done, showing alt text 
		active_dialogue.set_quest_dialogue_done()
	
	active_dialogue.select_page(0)

func in_dialogue() -> bool:
	return is_in_dialogue

func exit_dialogue():
	# quest could be removed if it was solved
	if SingletonPlayer.check_dialogue_finished(current_npc_id):
		SingletonPlayer.remove_quest_string(current_npc_id)
	is_in_dialogue = false
	# FIXME NUll-value 
	active_dialogue = null
	var quest_done:bool = SingletonPlayer.obtain_npc_quest_state(current_npc_id)
	var spoke_to_before:bool = SingletonPlayer.npc_check_spoke_to(current_npc_id)
	SingletonPlayer.npc_set_spoke_to(current_npc_id,true)
	print("spoke with npc " +  str(spoke_to_before))
	if not spoke_to_before and quest_done :
		print("showing quest done dialogue")
		SingletonPlayer.prepare_dialogue(current_npc_id)
		return 
	# hide panel
	npc_control_instance.hide()

func select_page(page: int):
	if active_dialogue == null:
		print("NO DIALOGUE STARTED, CAN'T CHANGE PAGE")
		return
		
	active_dialogue.select_page(page)
	
func btn_action(btn: int):
	print("calling button action in dialogue")
	var quest_state = SingletonPlayer.obtain_npc_quest_state(current_npc_id)
	var dialogue_state:bool = SingletonPlayer.check_dialogue_finished(current_npc_id)
	var dialogue_done:bool = quest_state and dialogue_state
	if active_dialogue == null:
		return
	print("activating dialogue")
	print(btn)
	active_dialogue.btn_action(btn,dialogue_done)
	

# THIS METHOD CHANGES THE DIALOGUE_DATA, SETS IT TO FINISHED, AS A CONSEQUENCE, IN THE NPC ITSELF, THE OBJECT IS GONNA CHANGE,
# THIS WAY, YOU FIND OUT, WHICH DIALOGUE IS COMPLETED
# FINISH_DIALOGUE ITSELF MUST BE CALLED FROM INSIDE A CONCRETE DIALOGUE
func finish_dialogue():
	if active_dialogue == null:
		print("NO DIALOGUE TO FINISH")
		return
	
	print("DIALOGUE FINISHED")
	
	active_dialogue.finished = true
