extends Dialogue_Data


class_name DynamicDialogue

var src_image: String
var empty_msg: String
# --- /
# -- / class constructor 
func _init(_empty_image: String, _empty_msg: String, _quest_done_image: String, _quest_done_msg: String):
	src_image = _empty_image
	empty_msg = _empty_msg
	
	quest_undone_entries = [
		EmptyDynamicDialoguePage.new(_empty_image, _empty_msg)
		]
		
	quest_done_entries = [
		DynamicQuestResolved.new(_quest_done_image, _quest_done_msg)
	]

func insert_pages(unsolved_pages:Array[DynamicPage],solved_pages:Array[DynamicPage]):
	#if len(pages) == 0:
		#entries = [EmptyDynamicDialoguePage.new(src_image, empty_msg)]
		#ret?urn
	# adding entries for unsolved_page
	add_dialogue_content(false,unsolved_pages)
	add_dialogue_content(true, solved_pages)
	# setting default entry to correctly set the dialogue available
	active_pages = quest_undone_entries

func add_dialogue_content(quest_done_dialogue:bool,retrieved_pages:Array[DynamicPage]):
	var generated_pages: Array[Dialogue_Entry] = []
	var max_page:int = len(retrieved_pages)-1
	var index:int = 0
	for page_entry:DynamicPage in retrieved_pages:
		var is_last_page:bool = index == max_page
		generated_pages.append(DynamigPageImpl.new(page_entry.__content, page_entry.src_image, index, max_page,is_last_page))
		index += 1
	# adding to corresponding entry
	if quest_done_dialogue:
		quest_done_entries = generated_pages
		return
	# setting unsolved_dialogue
	quest_undone_entries = generated_pages
	return
