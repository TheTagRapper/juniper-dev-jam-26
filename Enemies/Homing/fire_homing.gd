extends Node2D

@export var cooldown : float = 1.0

@export var projectile_tscn : PackedScene
var cooldown_remaining : float
var target : Node2D
@export var health = 150

func _ready():
	cooldown_remaining = cooldown
	target = get_tree().get_first_node_in_group("player")

var in_progress_projectiles = []

func _process(_delta) -> void:
	if health <= 0:
		queue_free()

	cooldown_remaining -= _delta
	if cooldown_remaining <= 0:
		cooldown_remaining = cooldown
		var new_projectile = fire()
			
		
	

func fire():
	print("firing homing")
	var projectile = projectile_tscn.instantiate()
	add_child(projectile) # _ready gets info from enemy
	projectile.reparent(get_tree().root)
	return projectile

func take_damage(dmg):
	health -= dmg
