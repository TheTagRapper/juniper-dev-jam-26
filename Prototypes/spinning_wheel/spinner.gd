extends Node2D

enum Choices {
	MELEE,
	RANGED,
	THROWN,
	MAGIC
}

var colours =  {
	Choices.MELEE: Color("#614ad3"),
	Choices.RANGED: Color( "#f7be16" ),
	Choices.THROWN: Color("#F9532f"),
	Choices.MAGIC: Color("#07bba5")
}

@onready var wheel: Sprite2D = $Wheel
@onready var pickupSpawn: Marker2D = $Spawn

@export var pickup: Node2D
@export var icons: Array[Texture2D]   # indexed by Choices: MELEE, RANGED, THROWN, MAGIC
@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func spin_to(final: Choices) -> void:
	var interval = 0.04
	while interval < 0.25:
		pickup.modulate = colours[randi() % colours.size()]
		await get_tree().create_timer(interval).timeout
		interval *= 1.18
	pickup.modulate = colours[final]
	
func spawnWeapon(pos: Marker2D):
	orient(pos)

	pickup.global_position = pickupSpawn.global_position
	pickup.modulate.a = 0;

	var choice = randi() % Choices.size()

	await wheel.spinToChoice(choice).finished

	pickup.global_rotation = (-global_transform.x).angle() - PI/2
	pickup.modulate = colours[choice]
	pickup.modulate.a = 1

	await pickup.throw()
	
func orient(pos: Marker2D):
	global_position = pos.global_position
	print("reached, angle = ", (pos.global_position - global_position).angle() + PI)
	global_rotation = pos.global_transform.x.angle() + PI
	print("now: ", global_rotation)
	print(pos.name, " diff = ", pos.global_position - global_position)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
