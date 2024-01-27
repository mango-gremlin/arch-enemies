extends Dialogue_Data


class_name QuestTrackNPC
var default_undone_text:String
# --- /
# -- / class constructor 
func _init():
	print("initialize quest tracker")
	default_undone_text = "I will not join you >:( The others need to do something for once. Then maybe I will help."
	quest_undone_entries = [
		QuestPage.new(default_undone_text,0,0)
		]
	# contains all entries that are displayed when the objective was solved 
	quest_done_entries = [
		QuestDonePage.new()
	]
	active_pages = quest_undone_entries
	# setting dialogue finish to true
	deactivate_undone_pages()
	
	# test case
	# querying the current state of quests 

# takes dictionary of quests and converts it to array of their strings 
#
# we obtain a dictionary that contains only known and unsolved quests
# we can therefore check their state and notify -> about solvable tasks
func extract_quests(quest_state:Dictionary) -> Array[String]: 
	var list_of_unsolved_quests:Array[String] = []
	for npc:int in quest_state:
		var quest_string:String = quest_state[npc]
		var quest_solvable:bool =SingletonPlayer.obtain_npc_quest_state(npc)
		if quest_solvable:
			quest_string += " solvable!"
		list_of_unsolved_quests.append(quest_string)
	return list_of_unsolved_quests

func update_dialogue(quest_dict:Dictionary):
	var unsolved_quests:Array[String] = extract_quests(quest_dict)
	insert_quests(unsolved_quests)

func insert_quests(quests:Array[String]):
	var max_page = len(quests) 
	
	quest_undone_entries = []
	var index = 1
	# adding base entry
	quest_undone_entries.append(QuestPage.new(default_undone_text,0,max_page))
	for quest in quests:
		print("adding quest to entry")
		quest_undone_entries.append(QuestPage.new(quest, index, max_page))
		index += 1
	# updating active dialogue entry
	active_pages = quest_undone_entries
