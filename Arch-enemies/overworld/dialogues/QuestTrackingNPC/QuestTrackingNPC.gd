extends Dialogue_Data


class_name QuestTrackNPC

# --- /
# -- / class constructor 
func _init():
	print("initialize quest tracker")
	entries = [NoQuestFoundPage.new()]
	
	# test case
	# querying the current state of quests 
	
	# FIXME no reason to initialize if overworld was not loaded -> no npc object available
	# key: quest-string -> value: state:Boolean
	#var quest_list:Dictionary = SingletonPlayer.obtain_all_quest_states()
	#var unsolved_quests:Array[String] = extract_unsolved_quests(quest_list)
	#
	#print(unsolved_quests)
	#insert_quests(unsolved_quests)

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
