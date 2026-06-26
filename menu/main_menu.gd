extends Control

@onready var logo = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	logo.play()
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Player/ui_testing_place/ui_test.tscn")
	pass # Replace with function body.
