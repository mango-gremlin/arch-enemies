extends Node

# class: Item
# --- / 
# describes an Item the player can obtain 
# - to trade with other NPCS
# - to recruit NPCS
# - .... 
class_name Item

enum ItemType {
	STICK,
	STONE,
	LEAF,
	HONEY,
	NOTHING,
}

# --- / 
# -- / base properties

var item_name:String
var item_description:String
var item_type:ItemType



# --- /
# -- / class constructor 
func _init(new_item_type:ItemType):
	item_type= new_item_type
	item_description = obtain_item_description(item_type)
	item_name = set_item_name(new_item_type)
	
	
	

# set description according to given itemType:
func obtain_item_description(Item:ItemType) -> String:
	match Item:
		ItemType.STICK:
			return "simple stick, nothing special"
		ItemType.STONE:
			return "yet another stone"
		ItemType.LEAF:
			return "leaf of unspecified tree origin"
		ItemType.HONEY:
			return "sweet honey"
		ItemType.NOTHING:
			return ""
		_:
			# should not occur
			return ""

# returns string representation of obtained item 
# TODO Where is it used?
func set_item_name(type:ItemType):
	match type:
		ItemType.STICK: 
			return "Stick"
		ItemType.STONE: 
			return "Stone"
		ItemType.LEAF: 
			return "Leaf"
		ItemType.HONEY: 
			return "Honey"
		_: 
			return " "
			


# FIXME maybe there's a better solution, the first google search was inconlusive. str() and to_string()
# does not work on enums?
func item_type_to_string(item_type_enum: ItemType):
	match item_type_enum:
		ItemType.STICK:
			return "STICK"
		ItemType.STONE:
			return "STONE"
		ItemType.LEAF:
			return "LEAF"
		ItemType.HONEY:
			return "HONEY"
		ItemType.NOTHING:
			return "NOTHING"
		_:
			return "ERROR"			
		
			

# converts itemtype to json representation 
# returns json-string representing item
func to_json():
	var data = {
		"type" : item_type_to_string(item_type),
		"item_description" : item_description
	}
	
	return data
	

# converts string to enum of type item
# returns obtained type
static func string_to_item_type(str):
	match str:
		"STICK": 
			return ItemType.STICK
		"STONE": 
			return ItemType.STONE
		"LEAF": 
			return ItemType.LEAF
		"HONEY": 
			return ItemType.HONEY
		#"NOTHING": 
		#	return ItemType.NOTHING
		_:
			# usually not the case 
			print("Invalid string representation received")
			return ItemType.NOTHING
	
