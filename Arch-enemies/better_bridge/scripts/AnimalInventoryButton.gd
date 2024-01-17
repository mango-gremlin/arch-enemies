extends Button

@export var animal_type : Animal.AnimalType = Animal.AnimalType.NONE

signal choose_animal_type(type : Animal.AnimalType)

func _ready():
	button_down.connect(_choose)

func _choose():
	choose_animal_type.emit(animal_type)
