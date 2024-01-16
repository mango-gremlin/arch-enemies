extends Dialogue_Data


class_name QuestTrackNPC

# --- /
# -- / class constructor 
func _init():
	entries = [NoQuestFoundPage.new()]
	
	# test case
	insert_quests(["Hallo", "Ich", "Bin", "Ein", "Test"])


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
