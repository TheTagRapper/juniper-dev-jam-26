extends Node2D

var parent
var projectile_count
var orbit_speed
var orbit_distance
var orbit_time

var weapon_inv = [null, null, null, null]
var holding_index = 0
var stack_of_free_indexes = [3, 2, 1, 0] # CHANGE AS WEAPONS CAN NO LONGER BREAK

var animated_sprite 
var idle_sprite 
var s_width
var s_height
var radius

@onready var emitter = get_tree().get_first_node_in_group("PlayerEmitter")

func _ready():
	parent = get_parent()
	projectile_count = parent.projectile_count
	orbit_speed = parent.orbit_speed
	orbit_distance = parent.orbit_distance
	orbit_time = 0


	# Required values for positioning weapons
	animated_sprite = parent.get_node("AnimatedSprite2D")
	idle_sprite = animated_sprite.sprite_frames.get_frame_texture("idle", 0)
	s_width = idle_sprite.get_width()
	s_height = idle_sprite.get_height()
	radius = sqrt((s_width/8) ** 2 + (s_height/8) ** 2)



func update_weapon_position(delta: float) -> void:
	
	orbit_time += delta
	
	# Updating weapon positions
	for i in range(4):
		if weapon_inv[i] != null:
			# Checking if durability is finished
			if weapon_inv[i].type == 1:
				if weapon_inv[i].durability <= 0:
					remove_weapon(i)
					return
			if weapon_inv[i].type == 2:
				if weapon_inv[i].ammo <= 0:
					remove_weapon(i)
					return
			
			
			var player_position = get_parent().position
			
			#if weapon_inv[i].needs_detachment == true:
			#	remove_weapon(i)
			# Check if it is being held in the hand
			if holding_index == i:
				# Point in a circle around the gun.
				var target_angle = (get_global_mouse_position() - get_parent().global_position).angle()
				weapon_inv[i].rotation = lerp_angle(weapon_inv[i].rotation, target_angle, delta * 10)
				weapon_inv[i].position.x = player_position.x + radius * cos(weapon_inv[i].rotation)
				weapon_inv[i].position.y = player_position.y + radius * sin(weapon_inv[i].rotation)
			# Letting them orbit around
			else:
				# Need to make the orbits uniform
				var orbit_index
				if i == 3:
					orbit_index = holding_index
				else:
					orbit_index = i
				
				weapon_inv[i].position.x = player_position.x + cos(2*PI/projectile_count * orbit_index + orbit_time * orbit_speed) * orbit_distance
				weapon_inv[i].position.y = player_position.y + sin(2*PI/projectile_count * orbit_index + orbit_time * orbit_speed) * orbit_distance



func add_weapon(area: Area2D):
	
	var no_of_weapons = 4 - len(stack_of_free_indexes)
	
	# Checking if full
	if no_of_weapons >= 0 and no_of_weapons < 4:		
		var weapon_index = stack_of_free_indexes.pop_back()
		weapon_inv[weapon_index] = area.get_parent()
		
		# Is in the 
		if no_of_weapons == 0:
			holding_index = weapon_index
			swap_weapons(holding_index + 1)

func remove_weapon(weapon_index : int):
	weapon_inv[weapon_index].queue_free()
	weapon_inv[weapon_index] = null
	stack_of_free_indexes.push_back(weapon_index)
	
	for m in range(0,3):
		if weapon_inv[m] != null:
			holding_index = m

func swap_weapons(selected_index : int):
	if weapon_inv[selected_index-1] != null:
		holding_index = selected_index - 1
		
		var held = weapon_inv[holding_index]
		
		if weapon_inv[holding_index].is_in_group("MELEE") :
			emitter.type = 1
			emitter.dmg = held.dmg
			emitter.durability = held.durability
		elif held.is_in_group("RANGED"):
			emitter.type = 2
			emitter.dmg = held.dmg
			emitter.ammo = held.ammo
			emitter.speed = held.speed
