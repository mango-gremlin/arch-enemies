extends Dialogue_Data


class_name DynamicDialogue

var src_image: String
var empty_msg: String
# --- /
# -- / class constructor 
func _init(_empty_image: String, _empty_msg: String):
	src_image = _empty_image
	empty_msg = _empty_msg
	
	entries = [
		EmptyDynamicDialoguePage.new(_empty_image, _empty_msg)
		]

func insert_pages(pages:Array[DynamicPage]):
	if len(pages) == 0:
		entries = [EmptyDynamicDialoguePage.new(src_image, empty_msg)]
		return
		
	var max_page = len(pages) - 1
		
	entries = []
	var index = 0
	
	for dynamic_page in pages:
		entries.append(DynamigPageImpl.new(dynamic_page.__content, dynamic_page.src_image, index, max_page))
		index += 1
