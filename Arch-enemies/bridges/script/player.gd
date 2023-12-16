extends CharacterBody2D


@export var speed : float
@export var jump_velocity : float

var start_position : Vector2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	start_position = self.global_position

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# if drag mode is entered, return fox to original position
	if Global.drag_mode:
		reset_player()
		return

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


# reset fox to start position, and remove velocity
func reset_player():
	velocity = Vector2.ZERO
	global_position = start_position


# if fox touches water
func _on_area_2d_body_entered(_body):
	reset_player()

# if fox comes in contact with DeathHazard
func _on_death_hazard_body_entered(_body):
	reset_player()

func _on_goal_area_2d_body_entered(_body):
	var goal_menu = get_parent().find_child("goal_menu")
	goal_menu.visible = true
