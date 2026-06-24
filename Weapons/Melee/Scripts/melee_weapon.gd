extends Node2D


var dir: Vector2
@onready var player = get_node(".")
var dmg: int 
var type
var speed: int 
@export var durability : int = 20
var id 

func _on_area_2d_body_entered(body: Node2D) -> void:
	# What happens when it collides with an enemy?
	pass
