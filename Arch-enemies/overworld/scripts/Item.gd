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
	HONEY,
	FLUTE,
	HAZELNUT,
	TASTY_LEAVES,
	SILK_SPOOL,
	STONE,
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
		ItemType.HONEY:
			return "Sweet honey"
		ItemType.FLUTE:
			return "Feeling like playing with me?"
		ItemType.HAZELNUT:
			return "A tasteful hazelnut"
		ItemType.TASTY_LEAVES:
			return "Tasty leaves of unspecified tree origin"
		ItemType.SILK_SPOOL:
			return "Silk spool"
		ItemType.STONE:
			return "Just a stone :("
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
static func set_item_name(type:ItemType):
	match type:
		ItemType.HONEY:
			return "Honey"
		ItemType.FLUTE:
			return "Flute"
		ItemType.HAZELNUT:
			return "Hazelnut"
		ItemType.TASTY_LEAVES:
			return "Tasty leaves"
		ItemType.SILK_SPOOL:
			return "Silk spool"
		ItemType.STONE:
			return "Stone"
		ItemType.NONE:
			return "None"
		_: # NONE
			return "Error"
			

func item_type_to_string(itemType: ItemType) -> String:
	match item_type:
		ItemType.HONEY:
			return "HONEY"
		ItemType.FLUTE:
			return "FLUTE"
		ItemType.HAZELNUT:
			return "HAZELNUT"
		ItemType.TASTY_LEAVES:
			return "TASTY_LEAVES"
		ItemType.SILK_SPOOL:
			return "SILK_SPOOL"
		ItemType.STONE:
			return "STONE"
		ItemType.NONE:
			return "NONE"
		_:
			return "NONE"
		

# converts itemtype to json representation 
# returns json-string representing item
func to_json():
	var data = {
		"type" : item_type_to_string(item_type),
		# "item_description" : item_description
	}
	
	return data
	

# converts string to enum of type item
# returns obtained type
static func string_to_item_type(str):
	match str:
		"HONEY": 
			return ItemType.HONEY
		"FLUTE": 
			return ItemType.FLUTE
		"HAZELNUT": 
			return ItemType.HAZELNUT
		"TASTY_LEAVES": 
			return ItemType.TASTY_LEAVES
		"SILK_SPOOL": 
			return ItemType.SILK_SPOOL
		"STONE": 
			return ItemType.STONE
		"NONE": 
			return ItemType.NONE
		_:
			# usually not the case 
			print("Invalid string representation received")
			return ItemType.NONE
		


# initalizes inventory with the corrosponding Item instances
static func init_items():
	var inventory:Dictionary = {}
	
	for item_type:ItemType in ItemType.values():
		if item_type == ItemType.NONE:
			continue
		inventory[item_type] = Item.new(item_type)
	
	return inventory
	
