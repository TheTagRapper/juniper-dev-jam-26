extends CharacterBody2D

var player:CharacterBody2D
@export var speed1:float = 100
@export var speed2:float = 200
var actual_speed:float

@export var health = 100

@export var dmg = 20



func _ready():
	player = get_tree().get_first_node_in_group("player")
	actual_speed = randf_range(speed1, speed2)

func _physics_process(delta):
	if player != null:
		var direction:Vector2 = (player.global_position - global_position).normalized()
		velocity = direction * actual_speed
		if player.global_position.x < global_position.x:
			$AnimatedSprite2D.play("left")
		else:
			$AnimatedSprite2D.play("right")
		
		move_and_slide()
	

func take_damage(dmg1:float):
	health-=dmg1
	print("EN HEALTH: " + str(health))
	if health<=0:
		get_parent().queue_free()
