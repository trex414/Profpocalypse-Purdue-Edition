extends Control

func _input(event):
	if event.is_action_pressed("trivia_book"):  # When "Z" is pressed
		toggle_book()

func toggle_book():
	var panel = $CanvasLayer/Panel
	panel.visible = !panel.visible
