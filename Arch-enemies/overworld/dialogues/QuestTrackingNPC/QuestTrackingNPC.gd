extends Dialogue_Data


class_name QuestTrackNPC

# --- /
# -- / class constructor 
func _init():
	entries = [ 
		QuestTrackNPC_Page1.new(),
		QuestTrackNPC_Page2.new()
	]
