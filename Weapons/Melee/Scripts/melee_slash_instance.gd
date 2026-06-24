extends Node2D

var dir: Vector2
@onready var player = get_node(".")
var durability: int  
var dmg: int 
var type
var speed: int 



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
		
	pass
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("enemy")):
		print("hit")
		body.take_damage(dmg)
		print("EN HEALTH: " + str(body.health))
	if(!body.is_in_group("player")):
		$".".queue_free()


func _on_attack_delete_timeout() -> void:
	queue_free()
	pass # Replace with function body.
