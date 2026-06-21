extends Sprite2D

enum RotationDirections {
	CLOCKWISE = 1,
	COUNTERCLOCKWISE = -1
}


@onready var tween := create_tween()


@export var rotation_direction: RotationDirections = RotationDirections.CLOCKWISE
@export var revolutions: int = 15
@export var spin_time: float = 3.0

var parent = get_parent()

const segment_size: float = PI / 2
const initial_offset: float = segment_size / 2

func spinToChoice(choice: int):
	return _spin(choice * segment_size - initial_offset + randf_range(0, segment_size));

func _spin(target_rotation: float):
	rotation = fmod(rotation, TAU)
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self,
		"rotation",
		target_rotation + revolutions * TAU * rotation_direction,
		spin_time
	)
	return tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotate(initial_offset)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
