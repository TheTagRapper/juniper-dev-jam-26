extends Node2D

@export var edges: Array[Node2D]
@export var icons: Array[Texture2D]

@onready var spinner: Node2D = $Machine

var knife : PackedScene = preload("res://Weapons/Melee/Scenes/MeleeWeapon.tscn")
var ak47 : PackedScene = preload("res://Weapons/Ranged/Scenes/RangedWeapon.tscn")

enum WEAPONS {KNIFE, AK47}

@export var weapon_pool_ENUMS : Array[WEAPONS]
var weapon_pool : Array[PackedScene]
var spawning = false
var unique_weapons : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for weapon in weapon_pool_ENUMS:
		match weapon:
			WEAPONS.KNIFE:
				if knife not in weapon_pool:
					unique_weapons += 1
					
				weapon_pool.append(knife)
				
			
			WEAPONS.AK47:
				if ak47 not in weapon_pool:
					unique_weapons += 1
				weapon_pool.append(ak47)
			_:
				assert("Blank spot in weapon_pool in Spinner")
	
				


func _unhandled_input(event):
	if event.is_action_pressed("Spin") and not spawning:
		_spawnWeapon()

func _spawnWeapon():
	spawning = true
	spinner.orient(edges[randi() % edges.size()])
	await spinner.spawnWeapons()	
	spawning = false
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
