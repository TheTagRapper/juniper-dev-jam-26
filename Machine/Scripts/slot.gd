extends Sprite2D

signal settled

enum Choices {
	MELEE,
	RANGED,
	THROWN,
	MAGIC
}

@onready var icons = $"../../..".icons

@onready var spawn_marker: Node2D = $Spawn

@onready var weapon_pool : Array[PackedScene] = $"../../..".weapon_pool

var weapon : PackedScene 

func spinToChoice(choice: int):
	var interval := 0.04
	while interval < 0.25:
		var random = randi() % icons.size() 
		texture = icons[random]
		weapon = weapon_pool[random] 
		await get_tree().create_timer(interval).timeout
		interval *= 1.18
	texture = icons[choice]
	weapon = weapon_pool[choice]
	print("Weapon Selected")
	settled.emit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
