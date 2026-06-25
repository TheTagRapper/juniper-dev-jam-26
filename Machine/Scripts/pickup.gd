extends Node2D

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var type: int

func setType(in_type):
	type = in_type
	sprite.texture = $"..".textures[type]
	
func throw():
	animation_player.play("spawn")
	await animation_player.animation_finished
