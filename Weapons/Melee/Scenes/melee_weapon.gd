extends Node2D

var dmg = 10
var durability = 10
var type = 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(dmg)
		durability -= 1
		$AudioStreamPlayer2D.play()
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.95,1.0)
	
	
