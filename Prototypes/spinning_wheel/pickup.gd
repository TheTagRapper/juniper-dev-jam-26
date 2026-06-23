extends Node2D


@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

func throw():
	animation_player.play("spawn")
	await animation_player.animation_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
