extends Node2D

@export var font: Font  # Assign your font resource in the Inspector

func _ready():
	apply_font_to_labels(get_tree().current_scene)

func apply_font_to_labels(node):
	if node is Label:
		node.add_theme_font_override("font", font)
	for child in node.get_children():
		apply_font_to_labels(child)
