extends Node2D


var direction:Vector2 = Vector2(0,0)
var bullet_speed:float = 300

func _physics_process(delta):
	global_position += direction * bullet_speed * delta


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		#add player damage function here
		queue_free()
