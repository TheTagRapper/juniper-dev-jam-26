extends Marker2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "no owner"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_index(index):
	$Label.text = str(index + 1)
