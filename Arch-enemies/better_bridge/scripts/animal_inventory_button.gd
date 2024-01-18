extends Button

@export var animal_type : Animal.AnimalType = Animal.AnimalType.NONE
@export var builder : BridgeBuilder
@export var inventory_count : Label

func _ready():
	button_down.connect(_choose)
	builder.update_ui.connect(_update_label)

func _choose():
	builder._set_preview_animal(animal_type)

func _update_label(type  : Animal.AnimalType, amount : int):
	if type == animal_type:
		inventory_count.text = str(amount)
