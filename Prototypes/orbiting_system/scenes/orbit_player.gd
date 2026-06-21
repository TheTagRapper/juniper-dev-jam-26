extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var weapon_inv = [-1, -1, -1, -1]
var holding_index = 0
var stack_of_free_indexes = [4, 3, 2, 1]

func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("move_right"):
		position.x += SPEED * delta
	if Input.is_action_pressed("move_left"):
		position.x -= SPEED * delta
	if Input.is_action_pressed("move_down"):
		position.y += SPEED * delta
	if Input.is_action_pressed("move_up"):
		position.y -= SPEED * delta
	
	move_and_slide()
	



func _on_area_2d_area_entered(area: Area2D) -> void:
	
	
	# Checking Collisions
	if area.is_in_group("WEAPON"):
		add_weapon(area)
		
	for i in range(4):
		weapon = weapon_inv[i]
		
		if weapon != -1:
			
			# Check if it is being held in the hand
			if holding_index == i:
				

func add_weapon(area: Area2D):
	
	var no_of_weapons = 4 - len(stack_of_free_indexes)
	
	# Checking if full
	if no_of_weapons >= 0 and no_of_weapons < 4:		
		var weapon_index = stack_of_free_indexes.pop_back()
		weapon_inv[weapon_index] = area.owner
		
		# Is in the 
		if no_of_weapons == 0:
			holding_index = weapon_index

func remove_weapon(weapon : Node2D , weapon_index : int):
	weapon.break_now()
	weapon_inv[weapon_index] = -1
	stack_of_free_indexes.push_back(weapon_index)
