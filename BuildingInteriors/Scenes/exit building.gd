extends Control

@onready var label = $Panel/Label

func _ready():
	hide()  # Hide the dialogue box initially

func _on_button_pressed() -> void:
	print("you pressed yes")  # Change to interior map
	var main_game = get_tree().root.get_node("TestMain")
	main_game.change_map("res://Main Map/scenes/Profpocalypse Main Map.tscn")
	hide()

func _on_button_2_pressed() -> void:
	print("you pressed no")
	hide()
