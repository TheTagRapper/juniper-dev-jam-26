extends Node2D

var dmg = 10
var ammo = 10
var speed = 1000
var type = 2



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(dmg/4)
	
