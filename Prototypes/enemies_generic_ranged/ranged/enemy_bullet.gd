extends Node2D


var direction:Vector2 = Vector2(0,0)
var bullet_speed:float = 300

var dmg = 10

func _physics_process(delta):
	global_position += direction * bullet_speed * delta
