extends CharacterBody2D

var player:CharacterBody2D


#state machine logic
enum enemy_state {chase, shooting}

var next_state: enemy_state = enemy_state.chase
var previous_state: enemy_state
var current_state: enemy_state

#speed logic
@export var speed1:float = 100
@export var speed2:float = 200
var actual_speed:float

const ENEMY_BULLET = preload("uid://bgc5xhjbnsees")

@export var health = 100

#enemy attack and cooldown_logic
@export var shoot_range:float = 300  #theres differecn between these two values so that the 
@export var chase_range:float = 400  #enemy does not just keep switching states incase of fast player movement
@export var cooldown_timer: float = 0.0
@export var shoot_cooldown: float = 1.0
var has_shot_once:bool = false #ensures the enemy has shot atleast once before leaving the shoot state

#projectile accuracy properties
@export var inaccuracy_curve: Curve
@export var max_inaccuracy_angle:float = 15
@export var max_inaccuracy_distance: float

@export var dmg = 10

func _ready():
	player = get_tree().get_first_node_in_group("player")
	actual_speed = randf_range(speed1, speed2)
	max_inaccuracy_distance = chase_range

func _physics_process(delta):
	previous_state = current_state
	current_state = next_state
	
	match current_state:
		enemy_state.chase:
			chase_player(delta)
		enemy_state.shooting:
			shoot_player(delta)
		_:
			pass



func chase_player(delta):
	var direction:Vector2 = (player.global_position - global_position).normalized()
	velocity = direction * actual_speed
	
	check_if_player_close()
	move_and_slide()

func shoot_player(delta):
	velocity = Vector2.ZERO
	move_and_slide()
	
	cooldown_timer -= delta
	if cooldown_timer <= 0.0:
		shoot()
		cooldown_timer = shoot_cooldown
		has_shot_once = true
	if global_position.distance_to(player.global_position)>=chase_range && has_shot_once:
		has_shot_once = false
		cooldown_timer = 0.0
		next_state = enemy_state.chase
	

func check_if_player_close():
	if global_position.distance_to(player.global_position) <= shoot_range:
		next_state = enemy_state.shooting

func shoot():
	var dist = global_position.distance_to(player.global_position)
	var bah = clamp(dist/max_inaccuracy_distance, 0.0, 1.0)
	var inaccuracy_factor = inaccuracy_curve.sample(bah)
	
	var inaccuracy_spread = deg_to_rad(max_inaccuracy_angle * inaccuracy_factor)
	var random_angle = randf_range(-inaccuracy_spread, inaccuracy_spread)
	
	var dir = (player.global_position - global_position).normalized()
	dir = dir.rotated(random_angle)
	
	var proj = ENEMY_BULLET.instantiate()
	proj.global_position = global_position
	proj.direction = dir
	get_tree().current_scene.add_child(proj)

func take_damage(dmg:float):
	health-=dmg
