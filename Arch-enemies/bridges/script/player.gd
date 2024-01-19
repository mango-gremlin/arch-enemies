extends CharacterBody2D


@export var speed : float
@export var jump_velocity : float
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var start_position : Vector2
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false
# Saves if an animation is currently playing
var animation_locked : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	start_position = self.global_position

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 250:
			animated_sprite.play("jump_fall")
		was_in_air = true
	elif was_in_air == true:
		land()

	# if drag mode is entered, return fox to original position
	if Global.drag_mode:
		reset_player()
		return

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "ui_up", "ui_down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	update_animation()
	update_facing_direction()


# reset fox to start position, and remove velocity
func reset_player():
	velocity = Vector2.ZERO
	global_position = start_position
	animated_sprite.play("idle")

# if fox comes in contact with goal zone
func _on_goal_area_2d_body_entered(_body):
	var goal_menu = get_parent().find_child("goal_menu")
	goal_menu.visible = true

# flip the sprite to the direction the player should be facing
func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

# change animation based on action
func update_animation():
	if not animation_locked:
		if direction.x != 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")

func jump():
	velocity.y = jump_velocity
	animated_sprite.play("jump_up")
	animation_locked = true

func land():
	animated_sprite.play("jump_down")
	animation_locked = true
	was_in_air = false


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "jump_down":
		animation_locked = false
	elif animated_sprite.animation == "jump_up":
		animated_sprite.play("jump_fly")
