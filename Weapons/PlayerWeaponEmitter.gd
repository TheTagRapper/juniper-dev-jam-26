extends Node2D

var type = 0
const SPEED = 300.0
var attack = preload("res://Weapons/Melee/Scenes/MeleeSlashInstance.tscn")
var ranged = preload("res://Weapons/Ranged/Scenes/RangedWeaponInstance.tscn")
var durability = 20 
var dmg = 10
var speed = 100
var ammo = 10
var dir: Vector2
var cooldown = false
@onready var muzzle: Marker2D = $Marker2D
var weapon
var isready:bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else: 
		scale.y = 1
	pass
	
	var held = get_held()
	if held != null:
		if Input.is_action_just_pressed("shoot") and isready == true:			
			if held.type == 1 and held.durability > 0:
				isready = false
				slice()
				$cooldown.start()
				
			elif held.type == 2 and held.ammo > 0:
				isready = false
				shoot()
				$cooldown.start()
		
		if Input.is_action_pressed("shoot") and isready:
			if held.type == 2:
				if held.weapon_name == held.WEAPONS.LMG and held.ammo > 0:
					isready = false
					shoot()
					$cooldown.wait_time = 60.0 / 500.0
					$cooldown.start()

func get_held():
	var orbit_system = get_parent().get_node("Orbit")
	return orbit_system.weapon_inv[orbit_system.holding_index]
	


func slice():
	var held = get_held()
	if held != null:
		var weapon = attack.instantiate()
		held.durability -= 1
		print(held.durability)
		$".".get_parent().add_child(weapon)
		weapon.global_position = muzzle.global_position
		weapon.type = type
		weapon.dmg = held.dmg 
		weapon.rotation = rotation
		
		$MeleeAudio2D.play()
		$MeleeAudio2D.pitch_scale = randf_range(0.95, 1.0)
		print("instantiated melee")
		
		
func shoot(): 
	var held = get_held()
	if held != null:
		var weapon2 = ranged.instantiate()
		#cool_time = 0.2
		weapon2.speed = held.speed
		held.ammo -= 1
		$".".get_parent().add_child(weapon2)
		weapon2.global_position = muzzle.global_position
		weapon2.type = type
		weapon2.dmg = held.dmg 
		weapon2.rotation = rotation
		$RangedAudio2D.play()
		$RangedAudio2D.pitch_scale = randf_range(0.95, 1.0)
		print("instantiated ranged")


func _on_cooldown_timeout() -> void:
	isready = true
	pass # Replace with function body.
