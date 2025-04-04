extends Node2D



func _ready():
	# Ensure the Area2D node's input event is connected
	$Area2D.connect("input_event", Callable(self, "_on_interacted"))


func _on_interacted(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Player clicked interactable!")
		
