extends Area2D


#@onready var player = get_node(".")
var ammo: int  
var dmg: int 
var type
var speed = 300
#var range = 0.0

func _physics_process(delta: float) -> void:
	
	var movement = transform.x * speed * delta
	position += movement

	#range += movement.length()
	#if range > 500:
	#	queue_free
	
func _on_bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.take_damage(dmg)
		print("ENEMY HEALTH: " + str(body.health))
		queue_free()
	if body.is_in_group("world"):
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemy"):
		area.get_parent().take_damage(dmg)
		queue_free()
	if area.is_in_group("world"):
		queue_free()
