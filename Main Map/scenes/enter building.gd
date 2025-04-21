extends Control

@onready var label = $Panel/Label

func _ready():
	hide()  # Hide the dialogue box initially

func _on_button_pressed() -> void:
	print("you pressed yes")  # Change to interior map
	var main_game = get_tree().root.get_node("TestMain")  # Adjust the path to your main game node
	print(Global.building_name)
	main_game.change_map("res://BuildingInteriors/Scenes/InteriorMap.tscn")
	hide()

func _on_button_2_pressed() -> void:
	print("you pressed no")
	Global.building_name = ""
	hide()
