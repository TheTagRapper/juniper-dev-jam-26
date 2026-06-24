extends CharacterBody2D


const SPEED = 300.0

#this is the hud scene thing

@onready var game_hud = $CanvasLayer/game_hud




# Orbiting Variables
@export var projectile_count = 3
@export var orbit_speed = 3.0
@export var orbit_distance = 60

var max_health = 50
var health = max_health

var animation_state = "idle"

func _ready():
	game_hud.get_node("healthbar").value = health
	game_hud.get_node("healthbar").max_value = max_health

func _physics_process(delta: float) -> void:

	#assigning health
	game_hud.get_node("healthbar").value = health

	# Selecting Movement
	animation_state = "idle"
	if Input.is_action_pressed("move_right"):
		position.x += SPEED * delta
		animation_state = "walking"
	if Input.is_action_pressed("move_left"):
		position.x -= SPEED * delta
		animation_state = "walking"

	if Input.is_action_pressed("move_down"):
		position.y += SPEED * delta
		animation_state = "walking"

	if Input.is_action_pressed("move_up"):
		position.y -= SPEED * delta
		animation_state = "walking"
	
	if animation_state != $AnimatedSprite2D.animation:
		$AnimatedSprite2D.play(animation_state)
	
	# Selecting Weapon
	if Input.is_action_pressed("select_first_weapon"):
		$Orbit.swap_weapons(1)
	elif Input.is_action_just_pressed("select_second_weapon"):
		$Orbit.swap_weapons(2)
	elif Input.is_action_just_pressed("select_third_weapon"):
		$Orbit.swap_weapons(3)
	elif Input.is_action_just_pressed("select_fourth_weapon"):
		$Orbit.swap_weapons(4)
	
	$Orbit.update_weapon_position(delta)
	
	if health <= 0:
		death_motion()
		
	move_and_slide()

func death_motion():
	queue_free()


# Signal connected from the Area2D of
func _on_area_2d_area_entered(area: Area2D) -> void:
	# Checking Collisions
	if area.is_in_group("WEAPON") and area.get_parent() not in $Orbit.weapon_inv:
		$Orbit.add_weapon(area)
	elif area.is_in_group("ENEMY_WEAPON"):
		take_damage(area.get_parent().dmg)
		area.get_parent().queue_free()
		

func take_damage(dmg):
	health -= dmg


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("it hurts twin")
	if body.is_in_group("ENEMY_WEAPON"):
		print("the enemy damage = " + str(body.dmg))
		take_damage(body.dmg)
