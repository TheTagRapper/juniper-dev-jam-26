extends Node2D

@export var target : Node2D
@export var cooldown : float

var projectile_tscn = preload("../scenes/prefabs/homing_projectile.tscn")
var cooldown_remaining

func _ready():
	cooldown_remaining = cooldown

func _process(_delta) -> void:
	cooldown_remaining -= _delta
	if cooldown_remaining <= 0:
		cooldown_remaining = cooldown
		fire()

func fire():
	print("firing homing")
	var projectile = projectile_tscn.instantiate()
	add_child(projectile)
	projectile.reparent(get_tree().root)
	
