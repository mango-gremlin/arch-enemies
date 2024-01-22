extends Node2D

func _ready():
	
	# plays animation of floating indicator (tells u to press E)
	$InteractionIndicator.play("indication")
