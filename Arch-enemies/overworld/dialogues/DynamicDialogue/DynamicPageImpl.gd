extends Dialogue_Entry


class_name DynamigPageImpl


var __content:String
var src_image:String
var __page_name:String
var current_page:int
var max_page:int
var is_last_page:bool 

# --- /
# -- / class constructor 
func _init(_content:String, _src_image:String, _page_name:String, _current_page:int, _max_page:int, last_page:bool):
	__content = _content
	src_image = _src_image
	__page_name = _page_name
	is_last_page = last_page
	
	if src_image == null: # case already handled in DialogueUI
		src_image = ""
	
	current_page = _current_page
	max_page = _max_page
	
func page_name() -> String:
	return __page_name

func content() -> String:
	return __content

func image_src() -> String:
	return src_image
	
# null ement in array means here disable button X
func btn_text() -> Array[String]:	
	return ["Previous", "Next", "Exit"]
	
func btn_states() -> Array[bool]:
	return [current_page == 0, current_page >= max_page, false]

# btn button in from left to right, starting with 0
func btn_action(btn: int):
	if btn == 0 and current_page > 0:
		SingletonPlayer.active_dialogue.select_page(current_page - 1)
	
	if btn == 1 and current_page < max_page:
		SingletonPlayer.active_dialogue.select_page(current_page + 1)
	
	if btn == 2:
		if is_last_page:
			# setting dialogue to be finished
			# necessary for deleting quest after it was resolved
			SingletonPlayer.active_dialogue.finish_dialogue()
		SingletonPlayer.exit_dialogue()
