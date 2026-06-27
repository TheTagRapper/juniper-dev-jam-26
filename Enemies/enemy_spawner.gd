extends Node2D

var basic_human = preload("res://Enemies/Generic/basic_enemy.tscn")
var homing_human = preload("res://Enemies/Homing/Human/Scenes/Drone.tscn")
var ranged_human = preload("res://Enemies/Ranged/Human/Scenes/ShotgunScientist.tscn")
var basic_supernatural = preload("res://Enemies/Generic/Supernatural/Scenes/ZombieDoctor.tscn")
var homing_supernatural = preload("res://Enemies/Homing/Supernatural/Scenes/Vampire.tscn")
enum ENEMY_TYPE {BASIC_HUMAN, RANGED_HUMAN, HOMING_HUMAN, BASIC_SUPERNATURAL, HOMING_SUPERNATURAL}

@export var spawn_area_width : float 
@export var spawn_area_height : float
@export var min_dist_from_player : float
@export var subwave_cooldown : float = 15
@export var subwave_sizes : Array[int]
@export var enemy_list : Array[ENEMY_TYPE] = [ENEMY_TYPE.BASIC_HUMAN, ENEMY_TYPE.RANGED_HUMAN, ENEMY_TYPE.HOMING_HUMAN]

signal all_subwaves_released

# possible enemy spawns
var enemy_pool 
var enemies_spawned_in_wave = 0
var spawning = false

var player
var subwave_cooldown_remaining
var subwaves_remaining

var subwave_index = 0
func _ready():
	player = get_tree().get_first_node_in_group("player")
	subwave_cooldown_remaining = subwave_cooldown
	enemy_pool = []
	for m in enemy_list:
		match m:
			ENEMY_TYPE.BASIC_HUMAN:
				enemy_pool.append(basic_human)
			ENEMY_TYPE.RANGED_HUMAN:
				enemy_pool.append(ranged_human)
			ENEMY_TYPE.HOMING_HUMAN:
				enemy_pool.append(homing_human)
			ENEMY_TYPE.BASIC_SUPERNATURAL:
				enemy_pool.append(basic_supernatural)
			ENEMY_TYPE.HOMING_SUPERNATURAL:
				enemy_pool.append(homing_supernatural)
				
	subwaves_remaining = subwave_sizes.size()


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
	#enemy.add_to_group("enemy")
	enemy.reparent(get_tree().root)
	print("No of Enemies: " + str(get_tree().get_node_count_in_group("enemy")))
	enemies_spawned_in_wave += 1
	if enemies_spawned_in_wave >= subwave_sizes[subwave_index]:
		spawning = false
		enemies_spawned_in_wave = 0
		subwave_index += 1
	
		if subwave_index >= subwave_sizes.size():
			all_subwaves_released.emit()

func _process(delta: float) -> void:
	
	var enemy_count = get_tree().get_node_count_in_group("enemy")
	#print(enemy_count)
	if subwave_cooldown_remaining <= 0 and subwaves_remaining > 0 and enemy_count <= 0:
		spawning = true
		subwave_cooldown_remaining = subwave_cooldown
		subwaves_remaining -= 1
	
	if spawning:
		spawn_enemy()
		print("Enemy: " + str(get_tree().get_nodes_in_group("enemy")))
	elif enemy_count <= 0:
		subwave_cooldown_remaining -= delta
	#DEBUG
	if Input.is_key_pressed(KEY_L):
		print("Subwave Cooldown: " + str(subwave_cooldown_remaining))
		print("Enemies left to spawn in subwave: " + str(enemy_count))


func _on_button_button_down() -> void:
	#remove_enemy
	var nme = get_tree().get_first_node_in_group("enemy")
	if nme != null:
		nme.queue_free()
