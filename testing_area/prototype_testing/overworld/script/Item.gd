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
	item_name = setItemName(new_item_type)
	
	
	
func setItemName(type:ItemType):
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
	
