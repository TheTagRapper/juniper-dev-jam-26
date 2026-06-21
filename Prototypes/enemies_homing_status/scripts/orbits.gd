extends Node2D

@export var projectile_count : int
@export var orbit_distance : float
@export var orbit_speed : float

var projectiles = []
var time = 0.0
var projectile_tscn = preload("../scenes/prefabs/projectile.tscn");

func _ready() -> void:
	for i in range(projectile_count):
		var projectile = projectile_tscn.instantiate()
		add_child(projectile)
		projectiles.append(projectile)
		projectile.position.x = cos(2*PI/(i+1)) * orbit_distance
		projectile.position.y = sin(2*PI/(i+1)) * orbit_distance

func _physics_process(delta: float) -> void:
	time += delta
	for i in range(projectiles.size()):
		projectiles[i].position.x = cos(2*PI/projectile_count * i + time * orbit_speed) * orbit_distance
		projectiles[i].position.y = sin(2*PI/projectile_count * i + time * orbit_speed) * orbit_distance
