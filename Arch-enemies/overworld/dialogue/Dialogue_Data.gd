# class: Dialogue_Data
# --- / 
# representation of the complete dialog
class_name Dialogue_Data

var entries: Array[Dialogue_Entry] = []
var currentEntry: int = 0
var finished: bool = false

# --- /
# -- / class constructor 
func _init():
	pass


func select_page(page: int):
	if page >= len(entries):
		print("ERROR, INVALID PAGE NUMBER SUPPLIED")
		return
	
	currentEntry = page
	
	# of course, no data type here, idk how to work with signals
	var control_instance = SingletonPlayer.dialogue.npc_control_instance
	
	var entry: Dialogue_Entry = entries[currentEntry]
	
	# set title and content
	control_instance.set_text(entry.content())
	
	# set button text
	control_instance.set_buttons(entry.btn_text())
	
	# set image resource
	control_instance.set_image_texture(entry.image_src())
	
	# show panel
	control_instance.show()

func btn_action(btn: int):
	entries[currentEntry].btn_action(btn)
