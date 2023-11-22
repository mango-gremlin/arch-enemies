extends StaticBody2D


var draggable = false
var is_inside_dropable = false
var body_ref
var offset : Vector2
var initial_pos : Vector2
var is_dragging = false

func _process(delta):
	if draggable:
		
		if Input.is_action_just_pressed("click"):
			initial_pos = self.global_position
			offset = get_global_mouse_position() - self.global_position
			self.is_dragging = true
			#print("click")
			
		if Input.is_action_pressed("click"):
			self.global_position = get_global_mouse_position() - offset
			
		elif Input.is_action_just_released("click"):
			self.is_dragging = false
			
#		elif Input.is_action_just_released("click"):
#			Global.is_dragging = false
#			var tween = get_tree().create_tween()
#
#			if is_inside_dropable:
#				#global_position = body_ref.position
#				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
#			else:
#				#global_position = initial_pos
#				tween.tween_property(self, "global_position", initial_pos, 0.2).set_ease(Tween.EASE_OUT)


func _on_area_2d_mouse_entered():
	if not self.is_dragging:
		self.draggable = true
		self.scale = Vector2(1.05, 1.05)
	
	#print("mouse entered")

func _on_area_2d_mouse_exited():
	if not self.is_dragging:
		self.draggable = false
		self.scale = Vector2(1, 1)
