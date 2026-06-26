extends Node2D

@export var dmg = 10
@export var ammo = 10
@export var speed = 1000
var type = 2



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(dmg/4)
	
