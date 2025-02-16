extends Node2D

var inventory = null  # Reference to the inventory

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print("Game started. Press E to open inventory.")
	
	# Set the window size to 1280x720 (720p resolution
	var window = get_viewport().get_window()
	if window:
		window.size = Vector2(1280, 720)
	
	

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()

func toggle_inventory():
	if inventory == null:
		inventory = load("res://Inventory/scenes/inventory.tscn").instantiate()
		add_child(inventory)  # Add inventory to scene
		print("Inventory opened.")
	else:
		inventory.queue_free()  # Remove inventory
		inventory = null
		print("Inventory closed.")
