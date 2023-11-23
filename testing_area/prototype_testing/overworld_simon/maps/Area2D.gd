extends Area2D

var player = null


func _on_body_entered(body):
	print("Collision detected")
	
	if player != null:
		player.damagePlayer(player.max_health)
