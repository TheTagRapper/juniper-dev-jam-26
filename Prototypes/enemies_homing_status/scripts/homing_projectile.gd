extends Node2D

@export var turn_limit : float
@export var speed : float
@export var dmg: float

var direction : Vector2
var target : Node2D
var homing : bool

func _ready():
	target = get_tree().get_first_node_in_group("player")
	direction = global_position.direction_to(target.position)
	homing = true
	look_at(target.global_position)

func rotate_to_target():
	var to_target = target.position - position
	var angle = direction.angle_to(to_target.normalized())
	if absf(angle) > 0.01:
		direction = direction.rotated(clampf(angle, -turn_limit, turn_limit))
	if absf(angle) > PI/4:
		homing = false

func move():
	if direction:
		global_position += direction * speed;

#func check_bounds(): # change for room
	#if (global_position.x < 0 || global_position.y < 0 
		#|| global_position.x > get_viewport_rect().size.x 
		#|| global_position.y > get_viewport_rect().size.y):
		#queue_free()

func _physics_process(_delta: float) -> void:
	if homing:
		rotate_to_target()
	move()
	#check_bounds()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(dmg)
	if body.is_in_group("enemy"):
		return
	var parent = get_parent()
	if parent != null:
		print("Homing hit " + body.name)
		get_parent().queue_free()
