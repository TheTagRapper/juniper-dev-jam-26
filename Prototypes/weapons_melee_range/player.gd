extends CharacterBody2D


const SPEED = 300.0
@export var attack = preload("res://Prototypes/weapons_melee_range/melee_range_weapon.tscn")

@export var durability = 20 
@export var dmg = 10
@export var type = ["MELEE", "RANGE"]
@export var speed = 100
@export var ammo = 10
@export var dir: Vector2

var cool_time = 3


func _ready():
	$cooldown.set_wait_time(cool_time)
	type = "MELEE"

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
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#Selecting type of weapon
	if Input.is_action_pressed("select_first_weapon"):
		type = "MELEE"
		#$Sprite2D.texture=ResourceLoader.load("res://images/swipe.png")
		print("Melee.")
		
	elif Input.is_action_just_pressed("select_second_weapon"):
		type = "RANGE"
		#$Sprite2D.texture=ResourceLoader.load("res://icon.svg")
		$CollisionShape2D.scale *= 0.5
		print("Range")
	
	move_and_slide()
	
	
	
func shoot():
	$cooldown.start()
	var weapon = attack.instantiate()
	print("instantiated")
	$".".get_parent().add_child(weapon)
	weapon.transform = $Emitter.global_transform
	weapon.type = type
	weapon.dmg = dmg 
	



func _on_cooldown_timeout() -> void:
	shoot()
	print("shot")
	pass # Replace with function body.
