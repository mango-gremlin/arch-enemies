# class: Dialogue_Entry
# --- / 
# representation of a single dialogue (with text & button actions),
# use this class as a template (inheritance)
class_name Dialogue_Entry

# --- /
# -- / class constructor 
func _init():
	pass


func title() -> String:
	return "default"
	

func content() -> String:
	return "no text specified"
	
	
# null ement in array means here disable button X
func btn_text() -> Array[String]:
	return ["Accept", "Decline", "Exit"]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
	pass
