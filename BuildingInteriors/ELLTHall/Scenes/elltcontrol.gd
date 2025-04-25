extends Control

@onready var label = $Panel/Label

func _ready():
	hide()  # Hide the dialogue box initially

func _on_button_pressed() -> void:
	print("you pressed yes")  # Change to interior map
	get_tree().change_scene_to_file("res://test_main.tscn")
	hide()

func _on_button_2_pressed() -> void:
	print("you pressed no")
	hide()
