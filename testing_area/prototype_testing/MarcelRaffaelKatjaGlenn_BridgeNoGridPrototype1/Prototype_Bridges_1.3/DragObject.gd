extends Node2D

var draggable = false
var is_inside_dropable = false
var dropzone_left
var original_pos_dropzone_left
var offset : Vector2
var initial_pos : Vector2
var is_dragging = false
var inside_object = false
var dropzone_left_occupied = false

func _process(delta):
	if draggable:
		
		if dropzone_left == null or original_pos_dropzone_left == null:
			# THIS HAS SO MANY BUGS BUT THEY ARE NOT RELEVANT NOW
			# this part initialises the positions, but it doesnt really work
			# exactly as intended
			self.dropzone_left = self.get_children()[2]
			self.original_pos_dropzone_left = self.dropzone_left.global_position
		
		if Input.is_action_just_pressed("click"):
			# will ensure the object follows mouse at begin of click
			self.initial_pos = self.global_position
			
			offset = get_global_mouse_position() - self.global_position
			self.is_dragging = true
			Global.something_is_being_dragged = true
			Global.currently_dragging = self.get_name()
			
		if Input.is_action_pressed("click"):
			# during the time mouse click is held down,
			# object continues following mouse
			self.global_position = get_global_mouse_position() - offset
			
		elif Input.is_action_just_released("click"):
			# when click is released:
			
			# 1. nothing is being currently dragged
			self.is_dragging = false
			Global.something_is_being_dragged = false
			Global.currently_dragging = null

			# 2. create the animation that plays to make the snapping a bit smoother
			var tween = get_tree().create_tween()

			if is_inside_dropable:
				# shift the position of the dropable area so our 
				# dragged object ends up in the right place
				
				# save original position of dropable zone
				self.original_pos_dropzone_left = self.dropzone_left.global_position
				
				# shift the position so it snaps perfectly to the side
				# FIXME: this is still buggy but mostly works
				self.dropzone_left.global_position.x = self.dropzone_left.global_position.x - (59/2) + (7/2)
				
				# if we can drop this here, play animation with the 
				# final position being the position of the dropable zone
				tween.tween_property(self, "position", self.dropzone_left.global_position, 0.2).set_ease(Tween.EASE_OUT)
				self.dropzone_left_occupied = true
			else:
				# if we cannot drop it here, let it snap back to its original position
				tween.tween_property(self, "global_position", self.initial_pos, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered():
	# if the mouse enters the area and we are not currently dragging this object
	# set this to draggable
	if not self.is_dragging:
		self.draggable = true
		self.scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited():
	# if mouse exits and this is not being dragged, it will not be dragged
	if not self.is_dragging:
		self.draggable = false
		self.scale = Vector2(1, 1)

func _on_snake_body_entered(body:StaticBody2D):
	# if the snake body touches a staticbody hitbox (body)
	# and this body is in the group drobable
	# set inside dropable to true so the process can register it as a dropable zone
	# and change the colour of the body we just touched to signify we can drop it here
	if body.is_in_group('dropable'):
		is_inside_dropable = true
		body.modulate = Color(Color.CORNFLOWER_BLUE, 1)
		self.dropzone_left = body
		

func _on_snake_body_exited(body):
	# if the snake body stops touching a staticbody that has the dropable group
	# set inside dropable to false & change the colour of that body back to original 
	if body.is_in_group('dropable'):
		is_inside_dropable = false
		body.modulate = Color(Color.AQUAMARINE, 0.7)
		self.dropzone_left_occupied = false
		self.dropzone_left.global_position = self.original_pos_dropzone_left
