extends Area2D
class_name Interactable

# enum denoting the interaction type

enum InteractionType { 
	NPC, # denotes interaction with NPC
	BRIDGE, # denotes BRIDGE-game
	BLOCKADE, # denotes areas where a bridge could've been built, is checked against player
	ITEM, # denotes interaction with Spot that supplies item
	DEBUG, # denotes DEBUG interactions
}

# defines type of action, i.e item, shop, dialogue
@export var interact_type:InteractionType = InteractionType.DEBUG


# default value at interaction
@export var interact_label = "none"

# denotes the value
@export var interact_value = "no interaction"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
