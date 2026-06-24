extends Node2D

var type = 1
const SPEED = 300.0
var attack = preload("res://Weapons/Melee/Scenes/melee_range_weapon.tscn")
var ranged = preload("res://Weapons/Ranged/Scenes/ranged_weapon.tscn")
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
	
	#Selecting type of weapon
	if Input.is_action_pressed("select_first_weapon"):
		type = 1
		print("Melee.")
		
	elif Input.is_action_just_pressed("select_second_weapon"):
		type = 2
		print("Range")
	
	
	if Input.is_action_just_pressed("shoot") and type == 1 and durability > 0 and isready == true:
		isready == false
		slice()
		$cooldown.start()
		
	elif Input.is_action_just_pressed("shoot") and type == 2 and ammo > 0 and isready == true:
		isready == false
		shoot()
		$cooldown.start()
	
func slice():
	
	var weapon = attack.instantiate()
	durability -= 1
	print(durability)
	$".".get_parent().add_child(weapon)
	weapon.global_position = muzzle.global_position
	weapon.type = type
	weapon.dmg = dmg 
	weapon.rotation = rotation
	
	print("instantiated melee")
		
func shoot(): 
	
	var weapon2 = ranged.instantiate()
	#cool_time = 0.2
	weapon2.speed = speed
	ammo -= 1
	$".".get_parent().add_child(weapon2)
	weapon2.global_position = muzzle.global_position
	weapon2.type = type
	weapon2.dmg = dmg 
	weapon2.rotation = rotation
	
	print("instantiated ranged")


func _on_cooldown_timeout() -> void:
	isready = true
	pass # Replace with function body.
