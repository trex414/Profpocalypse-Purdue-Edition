extends Node2D

@onready var hover_ui = $HoverUI  # Control node for UI
@onready var label = $HoverUI/Label
@onready var icon = $HoverUI/Icon  # Optional: TextureRect for the icon

func _ready():
	# Connect all Area2D nodes' signals dynamically
	for area in get_tree().get_nodes_in_group("Buildings"):
		if area is Area2D:  # ✅ Only connect signals if it's an Area2D
			area.mouse_entered.connect(_on_building_hovered.bind(area))
			area.mouse_exited.connect(_on_building_exited)
			print("Connected:", area.name)
		else:
			print("Warning: Skipping non-Area2D node in Buildings group ->", area.name)

func _on_building_hovered(area):
	print("Hovering over:", area.name, "with name:", area.building_name)
	hover_ui.global_position = get_viewport().get_mouse_position() + Vector2(10, 10)
	label.text = area.building_name
	hover_ui.visible = true

	if area.building_icon:
		icon.texture = load(area.building_icon)
		icon.visible = true
	else:
		icon.visible = false

func _on_building_exited():
	hover_ui.visible = false
	
