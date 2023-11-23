extends CharacterBody2D


@export var SPEED = 100
@export var zoomlevel:Vector2 = Vector2(1,1)
@onready var anim :  AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	player_movement(delta)


func player_movement(delta):
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= SPEED
		anim.play("back_walk")
	elif Input.is_action_pressed("move_down"):
		velocity.y += SPEED
		anim.play("front_walk")
	elif Input.is_action_pressed("move_left"):
		velocity.x -= SPEED
		anim.play("side_walk")
		anim.flip_h = true
	elif Input.is_action_pressed("move_right"):
		velocity.x += SPEED
		anim.play("side_walk")
		anim.flip_h = false
		
	elif velocity == Vector2.ZERO:
		anim.flip_h = false
		anim.play("front_idle")
	
	move_and_collide(velocity * delta)

# ----- 
# --- structure for interaction with Areas
# -----

 
func _on_interactionarea_area_entered(area):
	pass # Replace with function body.


func _on_interactionarea_area_exited(area):
	pass # Replace with function body.
