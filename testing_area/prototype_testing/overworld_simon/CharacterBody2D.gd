extends CharacterBody2D

@export var speed : float = 100.0

func _physics_process(delta):
	var animation = $CollisionShape2D/AnimatedSprite2D
	
	if Input.is_action_pressed("w") and Input.is_action_pressed("a"):
		animation.play("north_west")
	elif Input.is_action_pressed("w") and Input.is_action_pressed("d"):
		animation.play("north_east")
	elif Input.is_action_pressed("S_Button") and Input.is_action_pressed("a"):
		animation.play("south_west")
	elif Input.is_action_pressed("S_Button") and Input.is_action_pressed("d"):
		animation.play("south_east")
	elif Input.is_action_pressed("a"):
		animation.play("west")
	elif Input.is_action_pressed("d"):
		animation.play("east")
	elif Input.is_action_pressed("w"):
		animation.play("north")
	elif Input.is_action_pressed("S_Button"):
		animation.play("south")
	else:
		animation.stop()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction1 = Input.get_axis("a", "d")
	
	if direction1:# links direction1 = -1, rechts d1 = 1
		velocity.x = direction1 * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	var direction2 = Input.get_axis("w", "S_Button")
	
	
	
	if direction2:
		velocity.y = direction2 * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)	

	move_and_slide()
