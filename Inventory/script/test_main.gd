extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print("Game started. Press E to open inventory.")

	# Set the window size to 1280x720 (720p resolution)
	var window = get_viewport().get_window()
	if window:
		window.size = Vector2(1280, 720)

var inventory = null  # Reference to the inventory scene

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		# Check if inventory exists, otherwise create it
		if inventory == null:
			inventory = load("res://Inventory/scenes/inventory.tscn").instantiate()
			add_child(inventory)  # Add inventory to the scene
			print("Inventory opened.")
		else:
			inventory.toggle_inventory()  # Toggle visibility
