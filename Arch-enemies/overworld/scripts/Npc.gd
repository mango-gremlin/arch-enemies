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
# denotes in which state of the dialogue the npc is currently
# example: we just started talking to them and they now await an item from us 
var dialogue_state:int 

var has_quest:bool 


# --- /
# -- / class constructor 
func _init(name,id,linked_dialogue):
	pass
	

# generates dictionary containing every animal stored in AnimalType and returns it 
# here AnimalType.NONE is left out 
# FIXME --> this requires Animals to be represented as **Objects** of a class
# because they ought to hold their amount within!
static func init_animal_inventory():
	var animal_inventory:Dictionary = {}
	for animal_type:SingletonPlayer.AnimalType in SingletonPlayer.AnimalType.values():
		if not animal_type == SingletonPlayer.AnimalType.NONE:
			#animal_inventory[item_type] = Item.new(item_type)
			pass
	
	return animal_inventory
