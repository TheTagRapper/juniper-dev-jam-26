extends Node2D

var basic_human = preload("res://Enemies/Generic/Human/Scenes/basic_enemy.tscn")
var homing_human = preload("res://Enemies/Homing/Human/Scenes/homing_enemy.tscn")
var ranged_human = preload("res://Enemies/Ranged/Human/Scenes/ranged_enemy.tscn")



@export var spawn_area_width : float 
@export var spawn_area_height : float
@export var min_dist_from_player : float
@export var spawn_cooldown : float
@export var wave_size : int

# possible enemy spawns
var enemy_list = [basic_human, homing_human, ranged_human]
var enemy_pool = enemy_list.duplicate()
var enemies_spawned_in_wave = 0
var spawning = true

var player
var spawn_cooldown_remaining

func _ready():
	player = get_tree().get_first_node_in_group("player")
	spawn_cooldown_remaining = spawn_cooldown

func find_spawn_pos() -> Vector2:
	var rx = randf()*spawn_area_width
	var ry = randf()*spawn_area_height
	
	while (Vector2(rx, ry).distance_to(player.position) < min_dist_from_player):
		rx = randf()*spawn_area_width
		ry = randf()*spawn_area_height
	return Vector2(rx, ry)

func pick_enemy() -> PackedScene:
	if enemy_pool.is_empty():
		enemy_pool = enemy_list.duplicate()
	var enemy_idx = randi() % enemy_pool.size()
	return enemy_pool[enemy_idx]

func spawn_enemy():
	var pos = find_spawn_pos()
	var enemy = pick_enemy().instantiate()
	add_child(enemy)
	enemy.position = pos
	enemy.reparent(get_tree().root)
	enemies_spawned_in_wave += 1
	if enemies_spawned_in_wave >= wave_size:
		spawning = false
		enemies_spawned_in_wave = 0
	

func _process(delta: float) -> void:
	if spawning:
		spawn_cooldown_remaining -= delta
		if spawn_cooldown_remaining <= 0:
			spawn_cooldown_remaining = spawn_cooldown
			spawn_enemy()
