extends Dialogue_Data


class_name QuestTrackNPC

# --- /
# -- / class constructor 
func _init():
	print("initialize quest tracker")
	entries = [
		NoQuestFoundPage.new()
		]
	# contains all entries that are displayed when the objective was solved 
	quest_done_entries = [
		NPC_TRACKER_PageQuestDone1.new()
	]
	
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
	if len(quests) == 0:
		entries = [NoQuestFoundPage.new()]
		return
		
	var max_page = len(quests) - 1
		
	entries = []
	var index = 0
	
	for quest in quests:
		entries.append(QuestPage.new(quest, index, max_page))
		index += 1
