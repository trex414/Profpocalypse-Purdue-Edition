extends Node2D

var inventory = null
var hud = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print("Game started. Press E to open inventory.")

	# Load Inventory
	inventory = load("res://Inventory/scenes/inventory.tscn").instantiate()
	add_child(inventory)

	# Load HUD
	hud = load("res://Main HUD/Scenes/hud.tscn").instantiate()
	add_child(hud)

	# Pass inventory reference to HUD
	hud.set_inventory(inventory)

	# Set the window size to 1280x720 (720p resolution)
	var window = get_viewport().get_window()
	if window:
		window.size = Vector2(1280, 720)


func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		# Check if inventory exists, otherwise create it
		if inventory == null:
			inventory = load("res://Inventory/scenes/inventory.tscn").instantiate()
			add_child(inventory)  # Add inventory to the scene
			print("Inventory opened.")
		else:
			inventory.toggle_inventory()  # Toggle visibility
