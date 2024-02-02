extends CanvasLayer

class_name OverWorldUI

# quest tracking
@onready var quest_list_label = $Control/QuestsAndQuestBox/QuestContainer/quest_list
@onready var quest_container = $Control/QuestsAndQuestBox/QuestContainer
@onready var checkmarks = $Control/QuestsAndQuestBox/QuestContainer/Checkmarks.get_children()
@onready var quest_solveable_markers = $Control/QuestSolveable.get_children()

# load textures for quest solveable indicator and quest checked mark
@onready var quest_solveable_indicator = load("res://assets/art/ui_elements/quest_solve_indicator.png")
@onready var quest_empty_solve_indicator = load("res://assets/art/ui_elements/quest_solve_indicator_invis.png")
@onready var checked_checkmark = load("res://assets/art/ui_elements/checkmark_checked.png")

#@onready var playername_label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/PlayerName
# these two are technically redundant
@onready var item_list_label = $Control/Items/VBoxContainer/HBoxContainer3/VBoxContainer/item_list
@onready var animal_list_label = $Control/Animals2/VBoxContainer/HBoxContainer4/VBoxContainer/animal_list

# unfortunately the fastest way here is just to save the path to each label

# item labels
@onready var egg_number = $Control/Items/VBoxContainer/GridContainer/egg_number
@onready var evidence_number = $Control/Items/VBoxContainer/GridContainer/evidence_number
@onready var fly_number = $Control/Items/VBoxContainer/GridContainer/fly_number
@onready var hazelnut_number = $Control/Items/VBoxContainer/GridContainer/hazelnut_number

# animal labels
@onready var deer_number = $Control/Animals2/Animals/deer_number
@onready var snake_number = $Control/Animals2/Animals/snek_number
@onready var squirrel_number = $Control/Animals2/Animals/squirrel_number
@onready var spider_number = $Control/Animals2/Animals/spider_number

# Called when the node enters the scene tree for the first time.
func _ready():
	# connecting signal to singleton
	SingletonPlayer.connect("updated_item_inventory",_on_player_updated_inventory) 
	SingletonPlayer.connect("updated_animal_inventory",_on_animal_inventory_updated)
	SingletonPlayer.connect("updated_quest_list",_on_quest_list_updated)
	# initialize ui
	_update_item_inventory_label()
	_update_animal_inventory_label()
	# get "saved" quests from singleton
	var displayed_quests_from_singleton = SingletonPlayer.displayed_quests
	print("SAVED QUESTS:")
	print(displayed_quests_from_singleton)
	_update_quest_list()
	


var player_item_inventory:Dictionary = {}:
	set(new_dict):
		# if a new array was given, we update its value, also the label
		player_item_inventory = new_dict
		_update_item_inventory_label()

var player_animal_inventory:Dictionary = {}:
	set(new_dict):
		player_animal_inventory = new_dict
		_update_animal_inventory_label()

var player_active_quest_dictionary:Dictionary = {}:
	set(new_dict):
		player_active_quest_dictionary = new_dict
		_update_quest_list()
		

var player_quests_to_display:Dictionary = {}:
	set(new_dict):
		player_quests_to_display = new_dict
		_update_quest_list()

# iterates over each item type and displays how many of each
func _update_item_inventory_label():
	# iterate over item
	for item in player_item_inventory:
		var item_string:String  = ""
		var item_amount:int = player_item_inventory[item]
		var item_label
		
		item_string += str(item_amount) + "x "
		
		match item:
			Item.ItemType.EVIDENCE:
				item_label = evidence_number
			Item.ItemType.EGG:
				item_label = egg_number
			Item.ItemType.HAZELNUT:
				item_label = hazelnut_number
			Item.ItemType.FLIES:
				item_label = fly_number
			_:
				item_label = evidence_number
		
		item_label.text = item_string

# iterates over each animal type and displays how many of each
func _update_animal_inventory_label():
	
	for animal:Animal.AnimalType in player_animal_inventory:
		var label_string:String = ""
		var animal_amount:int = player_animal_inventory[animal]
		var label
		
		label_string += str(animal_amount) + "x "
		
		match animal:
			Animal.AnimalType.DEER:
				label = deer_number
			Animal.AnimalType.SNAKE:
				label = snake_number
			Animal.AnimalType.SQUIRREL:
				label = squirrel_number
			Animal.AnimalType.SPIDER:
				label = spider_number
			Animal.AnimalType.NONE:
				label = animal_list_label
		
		label.text = label_string

# iterates over received list of quests
# displays them formatted in newline 
# compares quest list in ui to quest list in singleton, adds new quests
# but does not remove solved quests.
# adds an empty checkmark to new quests
func _update_quest_list():
	var label_string:String = ""
	
	# add new quests to the list, but do not remove old ones:
	for quest_id:int in player_active_quest_dictionary:
		var quest_string:String = player_active_quest_dictionary[quest_id]
		
		if not is_displayed(quest_id):
			label_string += quest_string + "\n"
			
			# add this quest to the displayed quests dict
			player_quests_to_display[quest_id] = quest_string
			add_empty_checkmarks()
	
	quest_list_label.text += label_string
	
	# if this was the first quest, make the quest container visible (invisible beforehand
	# to avoid having a weird square in the ui)
	if (not quest_list_label.text == "") and (not quest_container.visible):
		quest_container.visible = true

# checks whether current quest id is already among the list of quests being displayed
func is_displayed(quest_id):
	var already_displayed = false
	
	for displayed_quest_id:int in player_quests_to_display:
		if displayed_quest_id == quest_id:
			already_displayed = true
	
	return already_displayed

# for each new quest, adds an empty checkmark
func add_empty_checkmarks():
	# go through checkmarks array and make the first invisible one visible
	# then return. because otherwise all checkmarks are immediately visible
	for checkmark in checkmarks:
		if not checkmark.visible:
			checkmark.visible = true
			return

# add a checked checkmark to solved quests in the list
func add_solved_checkmarks():
	for quest_id in player_quests_to_display:
		var quest_solved = SingletonPlayer.obtain_npc_quest_state(quest_id)
		var quest_id_idx = player_quests_to_display.keys().find(quest_id)
		
		if quest_solved:
			checkmarks[quest_id_idx].texture = checked_checkmark
			quest_solveable_markers[quest_id_idx].texture = quest_empty_solve_indicator

# add an indicator to signify you can talk to the npc to solve the quest
func add_solveable_indicators():
	for quest_id in player_quests_to_display:
		var npc_object:NPC_interaction = SingletonPlayer.obtain_npc_object(quest_id)
		var is_solveable = npc_object.check_quest_condition()
		var quest_id_idx = player_quests_to_display.keys().find(quest_id)
		
		# set the solveable indicator with idx = quest_id_index if quest solveable
		if is_solveable:
			quest_solveable_markers[quest_id_idx].texture = quest_solveable_indicator

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	add_solveable_indicators()
	add_solved_checkmarks()


# updates the internal inventories/lists upon signal received
func _on_player_updated_inventory(inventory):
	player_item_inventory = inventory

func _on_animal_inventory_updated(new_animal_inventory):
	player_animal_inventory = new_animal_inventory

func _on_quest_list_updated(new_quests):
	player_active_quest_dictionary = new_quests

# when leaving scene: save quests in singleton
func _on_tree_exiting():
	SingletonPlayer.displayed_quests = player_quests_to_display
	print("TRANSFERRED LIST")
