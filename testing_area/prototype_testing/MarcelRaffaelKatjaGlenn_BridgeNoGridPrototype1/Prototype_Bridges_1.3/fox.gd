extends CharacterBody2D


@export var SPEED : float = 300.0
@export var JUMP_VELOCITY : float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if Global.drag_mode:
		reset_fox()
		return

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func reset_fox():
	velocity.x = 0
	velocity.y = 0
	global_position = Vector2(74, 111)

func _on_area_2d_body_entered(body):
	# if fox touches water
	reset_fox()
