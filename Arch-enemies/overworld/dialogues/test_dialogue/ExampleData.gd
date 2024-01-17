extends Dialogue_Data


class_name ExampleData

# --- /
# -- / class constructor 
func _init():
	entries = [ 
		Page1.new(),
		Page2.new(),
		Page3.new(),
	]
	quest_done_entries = [
		PageQuestDone.new()
	]
