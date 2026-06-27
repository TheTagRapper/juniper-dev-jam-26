extends Node2D

@onready var enemy_spawner = $EnemySpawner

var we_in_endgame: bool = false

func _ready():
	enemy_spawner.all_subwaves_released.connect(on_all_subwaves_released)


func on_all_subwaves_released():
	we_in_endgame = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if we_in_endgame:
		#print(get_tree().get_node_count_in_group("enemy"))
		#print(get_tree().get_nodes_in_group("enemy"))
		if get_tree().get_node_count_in_group("enemy") <= 0:
			print("level ended")
			#change the scene to next level over here
