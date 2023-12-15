extends Node

# class: Item
# --- / 
# describes an Item the player can obtain 
# - to trade with other NPCS
# - to recruit NPCS
# - .... 
class_name Item

#TODO refactor to be contained in Singleton of Player
# see #134
# makes it easier to create a new inventory --> save management or initializing player
# easier to update structure then!
#var inventory_structure: Dictionary ={
	#Item.ItemType.STONE : Item.new(ItemType.STONE),
	#Item.ItemType.LEAF : Item.new(ItemType.LEAF),
	#Item.ItemType.HONEY : Item.new(ItemType.HONEY),
	#Item.ItemType.STICK : Item.new(ItemType.STICK),
#}

enum ItemType {
	STICK,
	STONE,
	LEAF,
	HONEY,
	NONE,
	
	# according to **Requirements set by Game design group** 
	# those Types are the final ones that will be implemented  
	# HONEY 
	# FLUTE
	# HAZELNUT
	# TASTY LEAVES 
	# SILK SPOOL 
	
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
# TODO update according to #148
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
		ItemType.NONE:
			return ""
		_:
			# should not occur
			return ""

# return item name
func obtain_name() -> String:
	return item_name 

func obtain_amount() -> int:
	return item_amount
	
func increase_amount():
	item_amount +=1 

func set_amount(newamount:int):
	item_amount = newamount

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
		ItemType.NONE:
			return "NOTHING"
		_:
			return "ERROR"			
		
			

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
			return ItemType.NONE
	
