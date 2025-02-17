extends Control

# Number of inventory slots
const SLOT_COUNT = 12
const COLUMNS = 3  # 3 slots per column
const ROWS = 4  # 4 rows

# Slot container reference
@onready var grid_container = $CanvasLayer/Panel/GridContainer  # Ensure you have a GridContainer in your scene
@onready var backpack_bg = $CanvasLayer/Panel/BackpackBG  # Reference to TextureRect
@onready var delete_button = $CanvasLayer/Panel/Delete
@onready var add_button = $"CanvasLayer/Panel/Add Item"

# Inventory data structure
var inventory = []
var selected_slot = null  # Track selected item slot

# Item types
enum ItemType { HEAL, ITEM }

# Sample items (for testing)
var heal_item = { "type": ItemType.HEAL, "texture": preload("res://Inventory/assets/heal.png"), "stackable": true, "count": 1 }
var item = { "type": ItemType.ITEM, "texture": preload("res://Inventory/assets/item.jpg"), "stackable": false, "count": 1 }

func _ready():
	backpack_bg.texture = preload("res://Inventory/assets/Backpack.png")  # Load backpack image
	setup_inventory()
	
	add_button.connect("pressed", Callable(self, "add_item"))
	delete_button.connect("pressed", Callable(self, "delete_item"))

# Function to generate inventory slots dynamically
func setup_inventory():
	inventory.clear()
	# Clear any existing slots
	for child in grid_container.get_children():
		child.queue_free()
	
	# Create new slots
	for i in range(SLOT_COUNT):
		var slot = Button.new()
		slot.custom_minimum_size = Vector2(64, 64)  # Adjust slot size
		slot.icon = preload("res://Inventory/assets/empty_slot1.png")  # Set button icon
		slot.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER  # Center the icon
		slot.expand_icon = true  # Ensure it resizes properly
		slot.connect("pressed", Callable(self, "select_item").bind(i))
		grid_container.add_child(slot)
		inventory.append(null)  # Initialize inventory with empty slots
	print("Inventory setup complete")

# Function to add an item to the inventory
func add_item():
	var new_item = heal_item if randi() % 2 == 0 else item  # Randomly choose an item type
	
	# Try to stack if item is stackable
	if new_item["stackable"]:
		for i in range(SLOT_COUNT):
			if inventory[i] != null and inventory[i]["type"] == new_item["type"]:
				inventory[i]["count"] += 1
				update_inventory()
				print("Stacked item in slot", i, "new count:", inventory[i]["count"])
				return
	
	# Find the first empty slot
	for i in range(SLOT_COUNT):
		if inventory[i] == null:
			inventory[i] = new_item.duplicate()  # Assign a copy of the item
			update_inventory()
			print("Added new item to slot", i)
			return
	
	print("Inventory full! Cannot add more items.")

func update_inventory():
	for i in range(SLOT_COUNT):
		var slot = grid_container.get_child(i)
		if inventory[i] != null:
			slot.icon = inventory[i]["texture"]
			slot.expand_icon = true  # Ensures the icon fits inside the button properly
			slot.text = str(inventory[i]["count"]) if inventory[i]["stackable"] else ""
		else:
			slot.icon = preload("res://Inventory/assets/empty_slot1.png")
			slot.text = ""  # Clear text if slot is empty

# Function to select an item slot
func select_item(slot_index):
	selected_slot = slot_index
	print("Selected slot:", slot_index)
	
	# Highlight selected slot
	for i in range(SLOT_COUNT):
		var slot = grid_container.get_child(i)
		slot.modulate = Color(1, 1, 1, 1) if i != selected_slot else Color(1, 1, 0.5, 1)  # Yellow highlight

# Function to delete selected item
func delete_item():
	if selected_slot != null and inventory[selected_slot] != null:
		inventory[selected_slot] = null
		update_inventory()
		print("Deleted item from slot", selected_slot)
		selected_slot = null
