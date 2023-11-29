extends StaticBody2D

var draggable = false
var is_inside_dropable = false
var is_inside_forbidden = false
var dropzone
var original_pos_dropzone
var mouse_offset : Vector2
var initial_pos : Vector2
var is_dragging = false
var inside_object = false
var dropzone_occupied = false
@export var grid_size : float = 10.0 # size of a square in grid

# checks if placement of animal relativ to other animal is correct
func is_correct_placement(body):
	var allowed = false
	var body_area2D = body.get_children()[2] # gets Area2D child, which can check for overlapping bodies
	var animal_type = Global.get_animal_type(body)
	
	# iterate through all overlapping bodies, and check if they are allowed or not
	for overlapping_body in body_area2D.get_overlapping_bodies():
		# if overlapping body is a forbidden one, it is never valid
		if overlapping_body.is_in_group("forbidden"):
			return false
		# if overlapping body is dropable, check specifics for animals
		elif overlapping_body.is_in_group("dropable"):
			# every animal can be dropped on another animal's top dropzone
			if overlapping_body.is_in_group("top_dropzone"):
				allowed = true
			# only squirrels and spiders can be dropped on another animal's side dropzones
			elif overlapping_body.is_in_group("side_dropzone") and (animal_type == "squirrel" or animal_type == "spider"):
				allowed = true
			# only spiders can be dropped on another animal's bottom dropzone
			elif overlapping_body.is_in_group("bottom_dropzone") and animal_type == "spider":
				allowed = true
	return allowed

func _process(_delta):
	if draggable and (!Global.currently_dragging or Global.currently_dragging == self.get_name())  && Global.drag_mode == true:		
		if Input.is_action_just_pressed("click"):
			# dragged object should be on top level
			self.top_level = true
			
			# will ensure the object follows mouse at begin of click
			self.initial_pos = self.global_position
			
			mouse_offset = get_global_mouse_position() - self.global_position
			self.is_dragging = true
			Global.something_is_being_dragged = true
			Global.currently_dragging = self.get_name()
			
		if Input.is_action_pressed("click"):
			# during the time mouse click is held down,
			# object continues following mouse
			self.global_position = get_global_mouse_position() - mouse_offset
			
		elif Input.is_action_just_released("click"):
			# when click is released:
			
			# 1. nothing is being currently dragged
			self.is_dragging = false
			Global.something_is_being_dragged = false
			Global.currently_dragging = null

			# 2. create the animation that plays to make the snapping a bit smoother
			var tween = get_tree().create_tween()
			
			# snap to nearest position in grid, but this doesn't update is_inside_forbidden/dropable
			# 	may use signal emmited by clicks to snap to grid instead
			# snaps the center of animal to the grid, which may become an issue for some sprite sizes
			var new_x =  round_to_nearest(self.global_position.x, grid_size)
			var new_y = round_to_nearest(self.global_position.y, grid_size)
			self.global_position = Vector2(new_x, new_y)
			
			tween.tween_property(self, "position", self.position, 0.2).set_ease(Tween.EASE_OUT)
			print("is_inside_dropable: ", is_inside_dropable) 
			print("is_inside_forbidden: " , is_inside_forbidden)
			
			# if placement is incorrect, snap back to original position
			# otherwise animal remains in current position, snapped to grid
			if not is_correct_placement(self):
				tween.tween_property(self, "global_position", self.initial_pos, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered():
	mouse_entered()
	
func mouse_entered():
	# if the mouse enters the area and we are not currently dragging this object
	# set this to draggable
	if not self.is_dragging && Global.drag_mode == true:
		self.draggable = true
		#self.scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited():
	mouse_exited()

func mouse_exited():
	# if mouse exits and this is not being dragged, it will not be dragged
	if not self.is_dragging:
		self.draggable = false
		#self.scale = Vector2(1, 1)

func _on_snake_body_entered(body):
	body_entered(body)
	
func body_entered(body):
	# if the snake body touches a staticbody hitbox (body)
	# and this body is in the group drobable
	# set inside dropable to true so the process can register it as a dropable zone
	# and change the colour of the body we just touched to signify we can drop it here
	if body.is_in_group('dropable'):
		print("entered dropable body")
		is_inside_dropable = true
		body.modulate = Color(Color.CORNFLOWER_BLUE, 1)
		self.dropzone = body
	# "not body self" prevents some unexpected results with overlapping collision zones
	# of self, but may also be a problem in the future 
	if body.is_in_group('forbidden') and not body == self:
		print("entered forbidden body")
		print(body.get_owner().name)
		print(self.name)
		is_inside_forbidden = true
		

func _on_snake_body_exited(body):
	body_exited(body)
	
func body_exited(body):
	# if the snake body stops touching a staticbody that has the dropable group
	# set inside dropable to false & change the colour of that body back to original 
	if body.is_in_group('dropable'):
		print("exited dropable body")
		is_inside_dropable = false
		body.modulate = Color(Color.AQUAMARINE, 0.7)
	if body.is_in_group('forbidden') and not body == self:
		print("exited forbidden body")
		is_inside_forbidden = false

# rounds to nearest multiple of b to a
func round_to_nearest(a:float, b:float):
	var grid_offset = fmod(a,b)
	if grid_offset < b / 2:
		return a - grid_offset
	else:
		return a + (b - grid_offset) 

# JUST SQUIRREL THINGS
func _on_squirrel_body_entered(body):
	body_entered(body)


func _on_squirrel_body_exited(body):
	body_exited(body)


func _on_squirrel_mouse_entered():
	mouse_entered()


func _on_squirrel_mouse_exited():
	mouse_exited()
