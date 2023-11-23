extends CharacterBody2D


@export var SPEED = 1000.0

@onready var anim :  AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= SPEED
		anim.play("back_walk")
	if Input.is_action_pressed("move_down"):
		velocity.y += SPEED
		anim.play("front_walk")
	if Input.is_action_pressed("move_left"):
		velocity.x -= SPEED
		anim.play("side_walk")
		anim.flip_h = true
	if Input.is_action_pressed("move_right"):
		velocity.x += SPEED
		anim.play("side_walk")
		
	if velocity == Vector2.ZERO:
		anim.flip_h = false
		anim.play("front_idle")
	
	move_and_collide(velocity * delta)

