extends Area2D

func _on_area_entered(body : Area2D):
	if body.collision_layer == 1:
		#print("enemy collision")
		get_parent().get_parent().queue_free()
