extends Node

# class: Item
# --- / 
# describes an Item the player can obtain 
# - to trade with other NPCS
# - to recruit NPCS
# - .... 
class_name Item

# denotes available items to represent those internally
enum ItemType {
	EVIDENCE,
	EGG,
	HAZELNUT,
	FLIES,
	NONE
}

# --- / 
# -- / base properties

var item_name:String
var item_description:String
var item_type:ItemType
# denotes amount of this item available
var item_amount:int 


# --- /
# -- / class constructor 
func _init(new_item_type:ItemType):
	item_type = new_item_type
	item_description = obtain_item_description(item_type)
	item_name = set_item_name(new_item_type)
	item_amount = 0


# set description according to given itemType:
func obtain_item_description(type:ItemType) -> String:
	match type:
		ItemType.EVIDENCE:
			return "THEY ARE ALL IN ON IT"
		ItemType.EGG:
			return "Very noticeably not a hazlenut"
		ItemType.HAZELNUT:
			return "A tasteful hazelnut"
		ItemType.FLIES:
			return "A bunch of flies from the river"
		_: # NONE
			return ""


# return item name
func obtain_name() -> String:
	return item_name 


func obtain_amount() -> int:
	return item_amount


func increase_amount():
	item_amount += 1

func decrease_amount():
	item_amount -= 1

func set_amount(newamount:int):
	item_amount = newamount


# returns string representation of obtained item 
static func set_item_name(type:ItemType) -> String:
	match type:
		ItemType.EVIDENCE:
			return "Evidence"
		ItemType.EGG:
			return "Egg"
		ItemType.HAZELNUT:
			return "Hazelnut"
		ItemType.FLIES:
			return "Flies"
		ItemType.NONE:
			return "None"
		_: # NONE
			return "Error"
			

static func item_type_to_string(item_type: ItemType) -> String:
	match item_type:
		ItemType.EVIDENCE:
			return "EVIDENCE"
		ItemType.EGG:
			return "EGG"
		ItemType.HAZELNUT:
			return "HAZELNUT"
		ItemType.FLIES:
			return "FLIES"
		ItemType.NONE:
			return "NONE"
		_:
			return "NONE"
		

# converts string to enum of type item
# returns obtained type
static func string_to_item_type(str):
	match str:
		"EVIDENCE": 
			return ItemType.EVIDENCE
		"EGG": 
			return ItemType.EGG
		"HAZELNUT": 
			return ItemType.HAZELNUT
		"FLIES": 
			return ItemType.FLIES
		"NONE": 
			return ItemType.NONE
		_:
			# usually not the case 
			print("Invalid string representation received")
			return ItemType.NONE

# initializes dictionary containing quantity for each item available
# structure: Key=ItemType, Value=Int -> denotes Amount of item
static func init_item_inventory() -> Dictionary:
	var item_inventory: Dictionary = {}
	for item_type:ItemType in ItemType.values():
		# iterate over every ItemType available
		if item_type != ItemType.NONE:
			item_inventory[item_type] = 0
	return item_inventory

