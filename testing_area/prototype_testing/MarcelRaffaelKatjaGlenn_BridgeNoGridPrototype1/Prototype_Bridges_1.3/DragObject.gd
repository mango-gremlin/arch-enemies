extends StaticBody2D

var draggable = false
var is_inside_dropable = false
var dropzone
var original_pos_dropzone
var offset : Vector2
var initial_pos : Vector2
var is_dragging = false
var inside_object = false
var dropzone_occupied = false
var grid_size : float = 10.0 # size of a square in grid


func _process(_delta):
	if draggable && Global.drag_mode == true:

		
		#initialize_dropzones()
		
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
			
			# snap to nearest position in grid
			print(self.position)
			self.position.x =  round_to_nearest(self.position.x, grid_size)
			self.position.y = round_to_nearest(self.position.y, grid_size)
			print(self.position)
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
				#self.original_pos_dropzone = self.dropzone_.global_position
				# not buggy, unless snakes touch each other, probably
				var drop_area = calculate_droparea(self.dropzone)
				
				# if we can drop this here, play animation with the 
				# final position being the position of the dropable zone
				tween.tween_property(self, "position", drop_area, 0.2).set_ease(Tween.EASE_OUT)
				
				# if dropzone WAS occupied but we switched to something else it is
				# no longer occupied
				# if it wasnt, then now we switched to it and it is occupied
				self.dropzone_occupied = not self.dropzone_occupied
		
			else:
				# if we cannot drop it here, let it snap back to its original position
				tween.tween_property(self, "global_position", self.initial_pos, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered():
	# if the mouse enters the area and we are not currently dragging this object
	# set this to draggable
	if not self.is_dragging && Global.drag_mode == true:
		self.draggable = true
		self.scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited():
	# if mouse exits and this is not being dragged, it will not be dragged
	if not self.is_dragging:
		self.draggable = false
		self.scale = Vector2(1, 1)

func _on_snake_body_entered(body):
	# if the snake body touches a staticbody hitbox (body)
	# and this body is in the group drobable
	# set inside dropable to true so the process can register it as a dropable zone
	# and change the colour of the body we just touched to signify we can drop it here
	if body.is_in_group('dropable'):
		is_inside_dropable = true
		body.modulate = Color(Color.CORNFLOWER_BLUE, 1)
		self.dropzone = body
		

func _on_snake_body_exited(body):
	# if the snake body stops touching a staticbody that has the dropable group
	# set inside dropable to false & change the colour of that body back to original 
	if body.is_in_group('dropable'):
		is_inside_dropable = false
		body.modulate = Color(Color.AQUAMARINE, 0.7)

#func initialize_dropzones():
#	if dropzone == null or original_pos_dropzone == null:
			# THIS HAS SO MANY BUGS BUT THEY ARE NOT RELEVANT NOW
			# this part initialises the positions, but it doesnt really work
			# exactly as intended
#			self.dropzone = self.get_children()[2]
#			self.original_pos_dropzone = self.dropzone.global_position

func calculate_droparea(body):
	# returns the new position of where to place the animal in relation to the dropzone,
	# because right now, the anchor point is in the middle of a body
	if body.is_in_group('left_dropzone'):
		return Vector2(self.dropzone.global_position.x - (59.0/2) + (7.0/2), self.dropzone.global_position.y)
	if body.is_in_group('top_dropzone'):
		return Vector2(self.dropzone.global_position.x - 13, self.dropzone.global_position.y - 13)
	if body.is_in_group('bottom_dropzone'):
		return Vector2(self.dropzone.global_position.x - 13, self.dropzone.global_position.y + 13)
		
# rounds to nearest multiple of b to a
func round_to_nearest(a:float, b:float):
	var offset = fmod(a,b)
	if offset < b / 2:
		return a - offset
	else:
		return a + (b - offset) 
