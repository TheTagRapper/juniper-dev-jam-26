extends Node2D

@export var turn_limit : float
@export var speed : float

var direction : Vector2
var target : Node2D
var homing : bool

func _ready():
	target = get_parent().target
	direction = (target.position - position).normalized()
	homing = true

func rotate_to_target():
	var to_target = target.position - position
	var angle = direction.angle_to(to_target.normalized())
	if absf(angle) > 0.01:
		direction = direction.rotated(clampf(angle, -turn_limit, turn_limit))
	if absf(angle) > PI/4:
		homing = false

func move():
	if direction:
		position += direction * speed;

func check_bounds(): # change for room
	if (global_position.x < 0 || global_position.y < 0 
		|| global_position.x > get_viewport_rect().size.x 
		|| global_position.y > get_viewport_rect().size.y):
		queue_free()

func _physics_process(_delta: float) -> void:
	if homing:
		rotate_to_target()
	move()
	check_bounds()
