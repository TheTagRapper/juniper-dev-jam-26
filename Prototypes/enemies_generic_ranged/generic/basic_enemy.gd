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
	var direction:Vector2 = (player.global_position - global_position).normalized()
	velocity = direction * actual_speed
	
	move_and_slide()
	

func take_damage(dmg1:float):
	health-=dmg1
	if health<=0:
		queue_free()
