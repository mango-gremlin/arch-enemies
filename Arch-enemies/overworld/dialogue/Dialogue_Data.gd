# class: Dialogue_Data
# --- / 
# representation of the complete dialog
class_name Dialogue_Data

var quest_undone_entries: Array[Dialogue_Entry] = []
var quest_done_entries: Array[Dialogue_Entry] = []
# denotes the actively selected set of pages
var active_pages:Array[Dialogue_Entry] = []
var currentEntry: int = 0
var finished: bool = false
var npc_name:String = ""

# used to disable two dialogue options and only use the dialogue_done entries
func deactivate_undone_pages():
	finished = true

# if called it sets the active dialogue to be the quest_done dialogue
func set_quest_dialogue_done():
	active_pages = quest_done_entries
	

func select_page(page: int):
	if page >= len(active_pages):
		print("ERROR, INVALID PAGE NUMBER SUPPLIED")
		return
	
	currentEntry = page
	
	# of course, no data type here, idk how to work with signals
	var control_instance = SingletonPlayer.active_dialogue.npc_control_instance
	var entry: Dialogue_Entry = active_pages[currentEntry]
	# set title and content
	control_instance.set_text(entry.content())
	# set button text
	control_instance.set_buttons(entry.btn_text())
	# set button states
	control_instance.set_buttons_state(entry.btn_states())
	# set name of npc 
	var header:String = entry.page_name()
	if header == "":
		header = npc_name
		
	control_instance.set_npc_name(header)
	# set image resource
	control_instance.set_image_texture(entry.image_src())
	# show panel
	control_instance.show()

func btn_action(btn: int,done_state:bool):
	if done_state:
		print("used entry for active quest")
		print(currentEntry)
		# should always close
		# quick fix
		quest_done_entries[currentEntry].btn_action(btn)
		return
	print("non finished condition")
	active_pages[currentEntry].btn_action(btn)
