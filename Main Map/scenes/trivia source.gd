extends Node2D

@export var trivia_index: int  # Set this in the Inspector

func _ready():
	connect("input_event", Callable(self, "_on_interacted"))

func _on_interacted(viewport, event, shape_idx):
	print("player interacted with interactabe?")
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("player clicked interactable")
		var book = get_node("res://Trivia/scenes/trivia_book.tscn")  # Reference your book system
		book.unlock_trivia(trivia_index)

		# Hide the interactable after collection (or queue_free() to remove it)
		visible = false
