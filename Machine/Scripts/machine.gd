extends Sprite2D

@export var pickups: Array[Node2D]
@onready var icons: Array[Texture2D] = $"..".icons

@onready var mainBody: Sprite2D = $Body/Main
@onready var arm: Sprite2D = $Body/Arm

@onready var slots: Array[Node] = $Slots.get_children()

@onready var currentMaxType: int 




func orient(pos: Marker2D):
	global_position = pos.global_position
	global_rotation = pos.global_transform.x.angle() - PI / 2
	pass

func bounceTween():
	var tween := create_tween()
	tween.tween_property(mainBody, "scale", Vector2(1.1, 0.9), 0.1)
	tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(mainBody, "scale", Vector2.ONE, 0.5)
	pass

func pullArm():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(arm, "rotation", deg_to_rad(35), 0.15)
	tween.tween_property(arm, "rotation", 0.0, 0.4)
	pass

func spawnWeapons():
	pullArm()
	bounceTween()
	var choices = [] 
	currentMaxType = $"..".unique_weapons
	
	for child in slots:
		choices.append(randi() % currentMaxType)
		child.spinToChoice(choices.back())
	
	for child in slots:
		await child.settled
	
	for i in slots.size():
		pickups[i].get_node("Sprite2D").visible = true

		var marker = slots[i].spawn_marker
		pickups[i].global_position = marker.global_position
		pickups[i].global_rotation = marker.global_rotation
		pickups[i].setType(choices[i])
		await pickups[i].throw()
		
		var weapon = slots[i].weapon.instantiate()
		get_parent().add_child(weapon)
		weapon.global_position = pickups[i].get_node("Sprite2D").global_position
		weapon.global_rotation = pickups[i].get_node("Sprite2D").global_rotation
		
		pickups[i].get_node("Sprite2D").visible = false
		
		pass

func addType():
	currentMaxType+=1
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
