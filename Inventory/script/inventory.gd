extends Control

# Number of inventory slots
const SLOT_COUNT = 12
const COLUMNS = 3  # 3 slots per column
const ROWS = 4  # 4 rows

# Slot container reference
@onready var grid_container = $CanvasLayer/Panel/GridContainer  # Ensure you have a GridContainer in your scene

func _ready():
	setup_inventory()
	await get_tree().process_frame  # Wait for one frame to ensure size is calculated
	center_inventory()  

func center_inventory():
	await get_tree().process_frame  # Ensure UI is fully initialized
	await get_tree().process_frame  # Wait an extra frame if needed
	
	# Force size update before getting inventory size
	size = Vector2(400, 300)  # Set a default size if not properly calculated
	
	var screen_size = get_viewport_rect().size  # Get the screen size
	var inventory_size = size  # Use the actual inventory panel size

	if inventory_size != Vector2.ZERO:
		global_position = (screen_size - inventory_size) / 2  # Center inventory
	else:
		print("Warning: Inventory size is still zero, using fallback size.")
		global_position = (screen_size - Vector2(400, 300)) / 2  # Use default size for positioning

# Function to generate inventory slots dynamically
func setup_inventory():
	# Clear any existing slots
	for child in grid_container.get_children():
		child.queue_free()

	# Create new slots
	for i in range(SLOT_COUNT):
		var slot = TextureRect.new()
		slot.custom_minimum_size = Vector2(64, 64)  # Adjust slot size
		slot.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		slot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		slot.texture = preload("res://Inventory/assets/empty_slot1.png")  # Change to your inventory slot texture
		grid_container.add_child(slot)

	print("Inventory setup complete")
