extends Node

var weapon_slots: Array = [null, null, null, null]
var slot_nodes: Array = []

func _ready():
	for i in 4:
		var node_name = "weapon" + str(i+1)
		slot_nodes.append(get_node(node_name))
	

func _process(delta):
	for i in 4:
		if weapon_slots[i] != null and weapon_slots[i].is_in_group("MELEE"):
			slot_nodes[i].get_node("ProgressBar").value = weapon_slots[i].durability
		elif weapon_slots[i] != null and weapon_slots[i].is_in_group("RANGED"):
			slot_nodes[i].get_node("HBoxContainer/ammo_label").text = str(weapon_slots[i].ammo)

func add_item(item:Node2D) -> int:
	for i in 4:
		if weapon_slots[i] == null:
			weapon_slots[i] = item
			update_slot_texture(i, item)
			add_max_durability_or_ammo(item, i)
			return i
	return -1

func remove_item(weapon_index):
	weapon_slots[weapon_index] = null
	update_slot_texture(weapon_index, null)
	

func update_slot_texture(index: int, item: Node2D):
	if item == null:
		slot_nodes[index].visible = false
	else:
		slot_nodes[index].visible = true
		slot_nodes[index].get_node("TextureRect").texture = item.get_node("Sprite2D").texture

func add_max_durability_or_ammo(item:Node2D, index: int):
	if item.is_in_group("MELEE"):
		slot_nodes[index].get_node("HBoxContainer").visible = false
		slot_nodes[index].get_node("ProgressBar").visible = true
		slot_nodes[index].get_node("ProgressBar").max_value = item.durability #need to change if we implement throwing weapons later
	
	if item.is_in_group("RANGED"):
		slot_nodes[index].get_node("ProgressBar").visible = false
		slot_nodes[index].get_node("HBoxContainer").visible = true
		slot_nodes[index].get_node("HBoxContainer/ammo_label").text = str(item.ammo)

func update_active_visual(index:int):
	for i in 4:
		var tween = create_tween()
		if i == index:
			tween.tween_property(slot_nodes[i],"modulate",Color(1, 1, 1, 1.0), 0.15)
			tween.parallel().tween_property(slot_nodes[i], "scale", Vector2(1.15, 1.15), 0.15)
		else:
			tween.tween_property(slot_nodes[i], "modulate", Color(1, 1, 1, 0.4), 0.15)
			tween.parallel().tween_property(slot_nodes[i], "scale", Vector2(1.0, 1.0), 0.15)
