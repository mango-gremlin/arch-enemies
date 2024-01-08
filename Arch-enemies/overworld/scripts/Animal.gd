extends Node

# class: Animal
# --- / 
# describes an Animal, specifically the AnimalType Enum
# - used for building bridges 
# - denote type of animals 
# - handles translating and interpreting the enum

class_name Animal

enum AnimalType{
	SNAKE,
	DEER,
	SQUIRREL,
	SPIDER,
	NONE
	#FOX.
	# possibly more 
}

# --- / 
# -- / 

# converts type to string and returns it 
static func type_to_string(animal:AnimalType) -> String: 
	match animal:
		AnimalType.SNAKE:
			return "Snake"
		AnimalType.DEER:
			return "Deer"
		AnimalType.SQUIRREL:
			return "Squirrel"
		AnimalType.SPIDER:
			return "Spider"
		_:
			return " "

static func string_to_type(animal_string:String) -> AnimalType:
	match animal_string:
		"SNAKE": 
			return AnimalType.SNAKE
		"DEER": 
			return AnimalType.DEER
		"SQUIRREL": 
			return AnimalType.SQUIRREL
		"SPIDER": 
			return AnimalType.SPIDER
		_:
			return AnimalType.NONE
		

# generates dictionary containing every animal stored in AnimalType and returns it 
# here AnimalType.NONE is left out 
# FIXME --> this requires Animals to be represented as **Objects** of a class
# because they ought to hold their amount within!
static func init_animal_inventory():
	var animal_inventory:Dictionary = {}
	for animal_type:Animal.AnimalType in Animal.AnimalType.values():
		if not animal_type == Animal.AnimalType.NONE:
			# creating entry and filling it with 0
			animal_inventory[animal_type] = 0
	return animal_inventory
