extends StaticBody2D

const STANDARD_COLOR = Color(Color.AQUAMARINE, 0.7)
const TRIGGERED_COLOR = Color(Color.CORNFLOWER_BLUE, 1)

var draggable := false
var is_inside_forbidden := false
var mouse_offset : Vector2
var initial_pos : Vector2
var is_dragging := false
var inside_object := false
var dropzone_occupied := false
@export var grid_size : float = 10.0 # size of a square in grid
@export var body_area2D : Area2D
var connected_to = null
var someone_connects_to_this = false

# checks if placement of animal relativ to other animal is correct
func is_correct_placement(body):
	# if another animal holds on to this one it cant move
	if body.someone_connects_to_this:
		print("Reject: Cannot move connecting piece")
		return false
	
	# check if body is inside a forbidden zone
	if not is_inside_forbidden:
		# gets Area2D child, which can check for overlapping bodies
		var animal_type : String = Global.get_animal_type(body)
		
		# check if head of snake is overlapping with an animal
		if animal_type == "snake":
			# iterate through all bodies overlapping with the head collision zone
			for overlapping_body in body.get_node("forbidden_Area2D").get_overlapping_bodies():
				# check if root StaticBody2D belongs to an animal group
				if (overlapping_body.is_in_group("snake")
					or overlapping_body.is_in_group("spider")
					or overlapping_body.is_in_group("squirrel")
					or overlapping_body.is_in_group("deer")):
					print("Reject: Head of snake overlaps")
					return false
		
		# checks for other animals being overlapped by the current placement
		for area in body_area2D.get_overlapping_areas():
			if(area.is_in_group("animal_body")):
				print("Reject: Overlaps with animal")
				return false
		
		# iterate through all overlapping bodies, and check if they are allowed or not
		for overlapping_body in body_area2D.get_overlapping_bodies():
			# if overlapping body is dropable, check specifics for animals
			if overlapping_body.is_in_group("dropable"):
				 #if the overlapping_body is not connected to the shore the current animal cant be connected to it
				if not overlapping_body.is_in_group("shore_dropzone") and not overlapping_body.get_owner().is_bridge_connected_to_shore():
					print("Reject: Not connected to shore")
					return false
				if not overlapping_body.is_in_group("shore_dropzone"):  #the shore has no animal_type therefore this check has to be skipped 
					# get type of animal that overlapping drop zone belongs to
					var overlapping_animal_type = Global.get_animal_type(overlapping_body.get_owner())
					# if overlap zone belongs to a spider, it is always allowed
					if overlapping_animal_type == "spider":
						body.connect_to_animal(overlapping_body)
						print("Accept: Connected to spider")
						return true
					
				# if not, normal rules apply
				# every animal can be dropped on another animal's top dropzone
				if overlapping_body.is_in_group("top_dropzone"):
					body.connect_to_animal(overlapping_body)
					print("Accept: On top dropzone of animal")
					return true
				# only squirrels and spiders can be dropped on another animal's side dropzones
				elif overlapping_body.is_in_group("side_dropzone") and (animal_type == "squirrel" or animal_type == "spider"):
					body.connect_to_animal(overlapping_body)
					print("Accept: Squirrel on side dropzone of animal")
					return true
				# only spiders can be dropped on another animal's bottom dropzone
				elif overlapping_body.is_in_group("bottom_dropzone") and animal_type == "spider":
					body.connect_to_animal(overlapping_body)
					print("Accept: Spider on bottom dropzone of animal")
					return true
		print("Reject: Not inside any recognized dropzone")
		return false
	print("Reject: Is inside forbidden")
	return false


func _process(_delta):
	if (draggable 
			and (not Global.currently_dragging or Global.currently_dragging == self.get_name())  
			and Global.drag_mode == true):
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
			# object continues following mouse position, rounded to grid size.
			var target_position_x = Global.round_to_nearest(get_global_mouse_position().x - mouse_offset.x, grid_size)
			var target_position_y = Global.round_to_nearest(get_global_mouse_position().y - mouse_offset.y, grid_size)
			self.global_position.x = target_position_x
			self.global_position.y = target_position_y
			
		elif Input.is_action_just_released("click"):
			# when click is released:
			
			# dropped object should not be on top level anymore
			self.top_level = false

			# nothing is being currently dragged
			self.is_dragging = false
			Global.something_is_being_dragged = false
			Global.currently_dragging = null

			# create the animation that plays to make the snapping a bit smoother
			var tween = get_tree().create_tween()
			
			# snaps the center of animal to the grid
			tween.tween_property(self, "position", self.global_position, 0.2).set_ease(Tween.EASE_OUT)
			# if placement is incorrect, snap back to original position
			# otherwise animal remains in current position
			if not is_correct_placement(self):
				tween.tween_property(self, "global_position", self.initial_pos, 0.2).set_ease(Tween.EASE_OUT)


func connect_to_animal(overlapping_body):
	if connected_to != null and not connected_to.is_in_group("shore_dropzone"):
		connected_to.get_owner().someone_connects_to_this = false
	connected_to = overlapping_body
	if not overlapping_body.is_in_group("shore_dropzone"):
		overlapping_body.get_owner().someone_connects_to_this = true
		


# checks recursivly if an animal is connected to the shore through other animals
func is_bridge_connected_to_shore():
	print("self animal type:",Global.get_animal_type(self))
	#connected to nothing
	if self.connected_to == null:
		print("is_bridge_connected_to_shore null False")
		return false
	else:
		# end of recursion connected to the shore
		if self.connected_to.is_in_group("shore_dropzone"):
			print("is_bridge_connected_to_shore connected_to: shore")
			return true
		#connected to another animal
		else:
			print("is_bridge_connected_to_shore connected_to:",Global.get_animal_type( self.connected_to.get_owner() ))
			return self.connected_to.get_owner().is_bridge_connected_to_shore()


func _on_area_2d_mouse_entered():
	mouse_entered()


func mouse_entered():
	# if the mouse enters the area and we are not currently dragging this object
	# set this to draggable
	if not self.is_dragging and Global.drag_mode == true:
		self.draggable = true


func _on_area_2d_mouse_exited():
	mouse_exited()


# if mouse exits and this is not being dragged, it will not be dragged
func mouse_exited():
	if not self.is_dragging:
		self.draggable = false


func body_entered(body):
	# if body stops touching a staticbody that has the dropable group
	# change the colour of that body
	if body.is_in_group('dropable'):
		body.modulate = TRIGGERED_COLOR
	# if body stops touching a forbidden group, update the variable
	if body.is_in_group('forbidden'):
		print("Entered forbidden body ", body)
		is_inside_forbidden = true


func body_exited(body):
	# if body stops touching a staticbody that has the dropable group
	# change the colour of that body back to original 
	if body.is_in_group('dropable'):
		body.modulate = STANDARD_COLOR
	# if body stops touching a forbidden group, update the variable 
	if body.is_in_group('forbidden'):
		print("Left forbidden body ", body)
		is_inside_forbidden = false


func _on_snake_body_entered(body):
	body_entered(body)


func _on_snake_body_exited(body):
	body_exited(body)


func _on_squirrel_body_entered(body):
	body_entered(body)


func _on_squirrel_body_exited(body):
	body_exited(body)


func _on_squirrel_mouse_entered():
	mouse_entered()


func _on_squirrel_mouse_exited():
	mouse_exited()


func _on_spider_body_entered(body):
	body_entered(body)


func _on_spider_body_exited(body):
	body_exited(body)


func _on_spider_mouse_entered():
	mouse_entered()


func _on_spider_mouse_exited():
	mouse_exited()
