extends Node2D

@export var cooldown : float

var projectile_tscn = preload("../scenes/prefabs/homing_projectile.tscn")
var cooldown_remaining : float
var target : Node2D

func _ready():
	cooldown_remaining = cooldown
	target = get_tree().get_first_node_in_group("player")

func _process(_delta) -> void:
	cooldown_remaining -= _delta
	if cooldown_remaining <= 0:
		cooldown_remaining = cooldown
		fire()

func fire():
	print("firing homing")
	var projectile = projectile_tscn.instantiate()
	add_child(projectile) # _ready gets info from enemy
	projectile.reparent(get_tree().root)
