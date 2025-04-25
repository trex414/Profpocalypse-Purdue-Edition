extends CanvasLayer

@onready var label = $Label  # Adjust path if needed

func show_loading_screen():
	print("showing loading screen")
	show()  # Show the loading screen
	await get_tree().process_frame  # Wait for a frame (optional delay)
	await get_tree().create_timer(1.0).timeout  # Fake loading time
	hide()  # Hide after loading
	print("done loading")
