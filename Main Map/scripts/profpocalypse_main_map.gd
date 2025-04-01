extends Node2D

@export var font: Font  # Assign your font resource in the Inspector

func _ready():
	apply_font_to_labels(get_tree().current_scene)

	for enemy in get_tree().get_nodes_in_group("enemies"):
		if PlayerData.is_enemy_defeated(enemy.enemy_name):
			print("Free enemy from tree =======")
			enemy.queue_free()

func apply_font_to_labels(node):
	if node is Label:
		node.add_theme_font_override("font", font)
	for child in node.get_children():
		apply_font_to_labels(child)
		
		
