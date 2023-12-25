extends Node

# --- / 
# -- / file representing NPC within game 
# 
#

# making internal types accessible within environment 
class_name NPC_interaction


# -- / 
# NPC can be flagged
# -> interaction with another npc required to obtain this one 
# -> item required to obtain this one 
# -> build a certain bridge ( or the itme behind it )
enum AnimalType{
	SNAKE,
	DEER,
	SQUIRREL,
	SPIDER,
	NONE
	#FOX.
	# possibly more 
}

# denotes Quest-Type of NPC
enum Quest{
	ITEM,
	BRIDGE,
	NPC,
	NONE,
}

# denotes which type of quest-reward is obtained 
# after solving npcs quest
enum QuestReward{
	ITEM,
	ANIMAL,
	NONE
}


# --- /
# -- / Class Definition

# --- / 
# -- / base properties

var npc_name:String
var npc_id:int


# --- /
# -- / class constructor 
func _init(name,id,linked_dialogue):
	pass
	

