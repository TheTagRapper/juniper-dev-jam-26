extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var projectile_count = 3
var orbit_speed = 4.0
var orbit_distance = 150
var time = 0

var weapon_inv = [null, null, null, null]
var holding_index = 0
var stack_of_free_indexes = [3, 2, 1, 0]

func _physics_process(delta: float) -> void:

	# Selecting Movement
	if Input.is_action_pressed("move_right"):
		position.x += SPEED * delta
	if Input.is_action_pressed("move_left"):
		position.x -= SPEED * delta
	if Input.is_action_pressed("move_down"):
		position.y += SPEED * delta
	if Input.is_action_pressed("move_up"):
		position.y -= SPEED * delta
	
	# Selecting Weapon
	if Input.is_action_pressed("select_first_weapon"):
		swap_weapons(1)
	elif Input.is_action_just_pressed("select_second_weapon"):
		swap_weapons(2)
	elif Input.is_action_just_pressed("select_third_weapon"):
		swap_weapons(3)
	elif Input.is_action_just_pressed("select_fourth_weapon"):
		swap_weapons(4)
	
	
	move_and_slide()
	
	time += delta
	
	# Updating weapon positions
	for i in range(4):
		if weapon_inv[i] != null:
			
			# Check if it is being held in the hand
			if holding_index == i:
				# THIS IS TEMPORARY GUN CODE, WE WILL HANDLE SHOOTING
				# THIS IS JUST ADDED FOR TESTING
				var s_width = $Sprite2D.texture.get_width()
				var s_height = $Sprite2D.texture.get_height()
				var radius = sqrt((s_width/8) ** 2 + (s_height/8) ** 2)
				
				weapon_inv[i].look_at(get_global_mouse_position())
				weapon_inv[i].position.x = position.x + radius * cos(weapon_inv[i].rotation)
				weapon_inv[i].position.y = position.y + radius * sin(weapon_inv[i].rotation)
			
			# Letting them orbit around
			else:
				# Need to make the orbits uniform
				var orbit_index
				if i == 3:
					orbit_index = holding_index
				else:
					orbit_index = i
				
				weapon_inv[i].position.x = position.x + cos(2*PI/projectile_count * orbit_index + time * orbit_speed) * orbit_distance
				weapon_inv[i].position.y = position.y + sin(2*PI/projectile_count * orbit_index + time * orbit_speed) * orbit_distance




func _on_area_2d_area_entered(area: Area2D) -> void:
	# Checking Collisions
	if area.is_in_group("WEAPON") and area.get_parent() not in weapon_inv:
		add_weapon(area)
		

	

func add_weapon(area: Area2D):
	
	var no_of_weapons = 4 - len(stack_of_free_indexes)
	
	# Checking if full
	if no_of_weapons >= 0 and no_of_weapons < 4:		
		var weapon_index = stack_of_free_indexes.pop_back()
		weapon_inv[weapon_index] = area.get_parent()
		
		# Is in the 
		if no_of_weapons == 0:
			holding_index = weapon_index
		
		area.get_parent().add_index(weapon_index)

func remove_weapon(weapon : Marker2D , weapon_index : int):
	weapon.break_now()
	weapon_inv[weapon_index] = null
	stack_of_free_indexes.push_back(weapon_index)

func swap_weapons(selected_index : int):
	if selected_index != null:
		holding_index = selected_index - 1
