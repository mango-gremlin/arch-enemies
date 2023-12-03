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
func _init(new_item_type:ItemType,description:String):
	item_type= new_item_type
	item_description = description
	item_name = set_item_name(new_item_type)
	
	
	
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
			
# maybe there's a better solution, the first google search was inconlusive. str() and to_string()
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
		
			
func to_json():
	var data = {
		"type" : item_type_to_string(item_type),
		"item_description" : item_description
	}
	
	return data
	
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
		"NOTHING": 
			return ItemType.NOTHING
		_:
			print("Invalid string item type representation!")
			return ItemType.NOTHING  # ????
	
