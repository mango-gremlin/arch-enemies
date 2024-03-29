extends CharacterBody2D


@export var speed : float
@export var jump_velocity : float
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var start_position : Vector2
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false
var parent
var has_jumped:bool = false

# For the coyote timer
@onready var coyote_timer:Timer = $CoyoteJumpTimer
@export var coyote_frames:int
var coyote:bool = false # Whether in coyote time or not
var last_floor:bool = false # Last frame's on-floor state

# Saves if an animation is currently playing
var animation_locked : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal play_sound(sound)

func _ready():
	start_position = self.global_position
	parent = get_parent()
	coyote_timer.set_wait_time(coyote_frames / 60.0)

func _physics_process(delta):
	if parent.menu_mode:
		return
	# Add the gravity.
	if not is_on_floor():
		if last_floor:
			coyote = true
			coyote_timer.start()
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
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote) and not has_jumped:
		play_sound.emit("JUMP")
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "ui_up", "ui_down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if velocity.x != 0 and is_on_floor():
		Global.walking = true
	else:
		Global.walking = false
	
	# Store is_on_floor for the next frame
	last_floor = is_on_floor()
	move_and_slide()
	update_animation()
	update_facing_direction()


# reset fox to start position, and remove velocity
func reset_player():
	velocity = Vector2.ZERO
	global_position = start_position
	animated_sprite.play("idle")

# FIXME code doesn't seem to be necessary? same as in goal.gd
## if fox comes in contact with goal zone
#func _on_goal_area_2d_body_entered(_body):
	#var goal_menu = get_parent().find_child("goal_menu")
	#goal_menu.visible = true

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
	has_jumped = true

func land():
	animated_sprite.play("jump_down")
	animation_locked = true
	was_in_air = false
	has_jumped = false

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "jump_down":
		animation_locked = false
	elif animated_sprite.animation == "jump_up":
		animated_sprite.play("jump_fly")

func _on_coyote_jump_timer_timeout():
	coyote = false
