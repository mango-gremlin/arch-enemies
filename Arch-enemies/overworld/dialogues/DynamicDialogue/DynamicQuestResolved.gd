extends Dialogue_Entry


class_name DynamicQuestResolved


var src_image: String
var resolved_msg: String
# --- /
# -- / class constructor 
func _init(_src_image: String, _empty_msg: String):
	src_image = _src_image
	resolved_msg = _empty_msg
	
	if src_image == null: # default pic
		src_image = "res://overworld/dialogues/test_dialogue/red.png"
	

func content() -> String:
	return resolved_msg

func image_src() -> String:
	return src_image
	
# null ement in array means here disable button X
func btn_text() -> Array[String]:
	return ["Exit", "", ""]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
	if btn == 0:
		SingletonPlayer.exit_dialogue()
