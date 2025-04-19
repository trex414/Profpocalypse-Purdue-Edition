extends Node2D

@onready var speech_label = $Message

func _ready():
	speech_label.visible = false

func _on_mouse_entered():
	speech_label.visible = true

func _on_mouse_exited():
	speech_label.visible = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		give_reward()

func give_reward():
	# Reward logic
	print("Reward given!")
