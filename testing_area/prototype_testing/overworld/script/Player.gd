extends CharacterBody2D


@export var SPEED = 100
@export var zoomlevel:Vector2 = Vector2(1,1)
@onready var anim :  AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	player_movement(delta)
	update_camera()

func update_camera():
	
	if Input.is_action_pressed("zoom_in"):
		if zoomlevel.x < 9:
			zoomlevel = Vector2(zoomlevel.x+.1, zoomlevel.y+.1)
	if Input.is_action_pressed("zoom_out"):
		if zoomlevel.x > 1:
			zoomlevel = Vector2(zoomlevel.x-.1, zoomlevel.y-.1)
	$PlayerCamera.zoom = zoomlevel

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

