extends Area2D

class_name Player

# emitting signal if collision occurs!
signal collision

@export var speed:float  = 200.0
@export var defaultZoom:Vector2 = Vector2(4,4)

# initializing values
var screen_size:Vector2 = Vector2.ZERO
var playerZoom:Vector2 = Vector2.ZERO
var sprite

# default values character
var health:int
var playerName:String
var inventory:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	# initializing basics for player
	screen_size = get_viewport_rect().size
	playerZoom = defaultZoom
	sprite = $sprite
	# initialize player properties
	playerName = "Eve"
	health = 100
	inventory = ["apple", "banana", "cucumber"]
	
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var velocity = Vector2.ZERO # setting velocity to 0
	
	## controlling zoom
	## ----
	
	if Input.is_action_pressed("zoom_in"):
		#print("zoom in")
		if playerZoom.x < 9:
			playerZoom = Vector2 ( 
				playerZoom.x+0.1, 
				playerZoom.y+0.1)
	
	if Input.is_action_pressed("zoom_out"):
		#print("zoom out")
		if playerZoom.x > 2:
			playerZoom = Vector2 ( 
				playerZoom.x-0.1, 
				playerZoom.y-0.1)
	# update camera zoom
	$Camera2D.zoom = playerZoom
	
	## ---- 
	
	# checking for inputs accordingly
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		sprite.play("left")
	else:
		sprite.stop()
		
	# fixing position to stay within the screen
	position += velocity * delta 
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		sprite.animation = "left"
		sprite.flip_v = false
		# See the note below about boolean assignment.
		sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		sprite.animation = "left"
		sprite.flip_v = true
		sprite.flip_h = velocity.y < 0
		
	

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func is_collision():
	collision.emit()

func interactWithBody():
	pass
	#while true:
		#if(Input.is_action_pressed())
	

func _on_body_entered(body):
	is_collision()
