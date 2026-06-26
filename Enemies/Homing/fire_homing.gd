extends Node2D

@export var cooldown : float

@export var projectile_tscn : PackedScene
var cooldown_remaining : float
var target : Node2D
var health

func _ready():
	cooldown_remaining = cooldown
	target = get_tree().get_first_node_in_group("player")

var in_progress_projectiles : Array[PackedScene]

func _process(_delta) -> void:
	if health <= 0:
		queue_free()

	cooldown_remaining -= _delta
	if cooldown_remaining <= 0:
		cooldown_remaining = cooldown
		$AnimatedSprite2D.play("fire")
		var new_projectile = await fire()
		in_progress_projectiles.append(new_projectile)
		
		for i in range(0, in_progress_projectiles.size()):
			var projectile = in_progress_projectiles[i]
			if not is_instance_valid(projectile):
				in_progress_projectiles.remove_at(i)
			
		if in_progress_projectiles.size() == 0:
			$AnimatedSprite2D.play("idle")
		
	

func fire():
	print("firing homing")
	var projectile = projectile_tscn.instantiate()
	add_child(projectile) # _ready gets info from enemy
	projectile.reparent(get_tree().root)
	return projectile

func take_damage(dmg):
	health -= dmg
