extends Node2D

@export var trivia_index: int  # Set this in the Inspector

func _ready():
	# Ensure the Area2D node's input event is connected
	$Area2D.connect("input_event", Callable(self, "_on_interacted"))

func _on_interacted(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Player clicked interactable!")

		# Find the existing TriviaBook node in the current scene
		var book = get_tree().current_scene.find_child("TriviaBook", true, false)

		if book:
			book.unlock_trivia(trivia_index)
		else:
			print("Error: TriviaBook node not found!")

		# Hide or remove the interactable after interaction
		visible = false  # Or use queue_free() to remove it
