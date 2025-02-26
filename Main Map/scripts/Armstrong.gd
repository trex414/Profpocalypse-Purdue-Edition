extends Area2D

@export var building_name: String = "Neil Armstrong Hall of Engineering"
@export var building_icon: String = ""

@onready var hover_ui = $"../HoverUI"  # Assuming UI is a sibling node
@onready var label = $"../HoverUI/Label"

func _on_mouse_entered():
	hover_ui.global_position = get_viewport().get_mouse_position() + Vector2(10, 10)
	label.text = building_name
	hover_ui.visible = true

func _on_mouse_exited():
	hover_ui.visible = false
