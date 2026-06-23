extends Node2D

@export var edges: Array[Node2D]

@onready var spinner: Node2D = $Spinner

var spawning = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _unhandled_input(event):
	if event.is_action_pressed("Spin") and not spawning:
		_spawnWeapon()

func _spawnWeapon():
	spawning = true
	await spinner.spawnWeapon(edges[randi() % edges.size()])	
	spawning = false
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
