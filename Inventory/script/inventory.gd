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
@onready var message_label = $CanvasLayer/Panel/Label  # Add a Label node to UI
@onready var use_button = $"CanvasLayer/Panel/Use Usable"



var inventory = InventoryManager.inventory

# Inventory data structure
var selected_slot = null  # Track selected item slot

# Item types
enum ItemType {ITEM , SPELL}

var spell_messages = {
	"HEAL": "You have been healed",
	"SPEED": "You are faster"
}

# Sample items (for testing)
var item_items = [
	{ "type": ItemType.ITEM, "name": "ITEM1", "texture": preload("res://Inventory/assets/Pickaxe.jpg"), "stackable": false, "count": 1 },
	{ "type": ItemType.ITEM, "name": "ITEM2", "texture": preload("res://Inventory/assets/Axe.png"), "stackable": false, "count": 1 }
]
var spell_items = [
	{ "type": ItemType.SPELL, "name": "HEAL", "texture": preload("res://Inventory/assets/heal.png"), "stackable": true, "count": 1 },
	{ "type": ItemType.SPELL, "name": "SPEED", "texture": preload("res://Inventory/assets/speed.png"), "stackable": true, "count": 1 }
]
func _ready():
	backpack_bg.texture = preload("res://Inventory/assets/Backpack.png")  # Load backpack image
	$CanvasLayer/Panel/Label/ColorRect.visible = false
	setup_inventory()
	add_button.connect("pressed", Callable(self, "add_item"))
	delete_button.connect("pressed", Callable(self, "delete_item"))
	use_button.connect("pressed", Callable(self, "use_item"))
	toggle_inventory()

func toggle_inventory():
	var panel = $CanvasLayer/Panel
	panel.visible = !panel.visible  # Toggle visibility

	# Update inventory UI when opening
	if panel.visible:
		update_inventory()
		print("Inventory opened.")
	else:
		print("Inventory closed.")
		
# Function to generate inventory slots dynamically
func setup_inventory():
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
	inventory = InventoryManager.inventory  # Use global inventory reference
	update_inventory()  # Show existing items
		
	print("Inventory setup complete")

# Function to add an item to the inventory
func add_item():
	# Randomly choose whether to add an ITEM or SPELL
	var category = randi() % 2  # 0 for ITEM, 1 for SPELL
	var new_item = null

	if category == 0:
		new_item = item_items[randi() % item_items.size()]  # Pick a random item
	else:
		new_item = spell_items[randi() % spell_items.size()]  # Pick a random spell
	
	# Adds new item to the inventory array in Player Data
	PlayerData.inventory.append(new_item)
	print(PlayerData.get_game_state()) # Print for testing (confirm item is in inventory)

	# Try to stack if item is stackable
	if new_item["stackable"]:
		for i in range(SLOT_COUNT):
			if inventory[i] != null and inventory[i]["name"] == new_item["name"]:
				inventory[i]["count"] += 1
				update_inventory()
				print("Stacked item in slot", i, "new count:", inventory[i]["count"])
				return
	
	# Find the first empty slot
	for i in range(SLOT_COUNT):
		if inventory[i] == null:
			inventory[i] = new_item.duplicate()  # Assign a copy of the item
			update_inventory()
			print("Added new item:", new_item["name"], "to slot", i)
			return
	
	print("Inventory full! Cannot add more items.")

func update_inventory():
	for i in range(SLOT_COUNT):
		var slot = grid_container.get_child(i)
		if slot is Button:  # Ensure it's a Button before assigning an icon
			if inventory[i] != null:
				slot.icon = inventory[i]["texture"]
				slot.expand_icon = true  # Ensures the icon fits inside the button properly
				slot.text = str(inventory[i]["count"]) if inventory[i]["stackable"] else ""
			else:
				slot.icon = preload("res://Inventory/assets/empty_slot1.png")
				slot.text = ""  # Clear text if slot is empty

# Function to select an item slot
func select_item(slot_index):
	# If no item is selected, pick up the item
	if selected_slot == null:
		if inventory[slot_index] != null:
			selected_slot = slot_index
			print("Picked up item from slot:", slot_index)
		if inventory[slot_index] != null:
			selected_slot = slot_index

	else:
		# If an item is already selected, move or swap it
		if selected_slot != slot_index:
			# Swap items if destination slot is occupied
			var temp = inventory[slot_index]
			inventory[slot_index] = inventory[selected_slot]
			inventory[selected_slot] = temp
			print("Moved item from slot", selected_slot, "to slot", slot_index)

		# Reset selection after moving
		selected_slot = null
		update_inventory()

	# Highlight selected slot (only if still selected)
	for i in range(SLOT_COUNT):
		var slot = grid_container.get_child(i)
		slot.modulate = Color(1, 1, 1, 1) if i != selected_slot else Color(1, 1, 0.5, 1)  # Yellow highlight

func deselect_item():
	if selected_slot != null:
		# Reset all slots to default color
		for i in range(SLOT_COUNT):
			var slot = grid_container.get_child(i)
			slot.modulate = Color(1, 1, 1, 1)  # Reset to normal color

		selected_slot = null  # Deselect item
		update_inventory()  # Refresh UI

# Function to delete selected item
func delete_item():
	if selected_slot != null and inventory[selected_slot] != null:
		inventory[selected_slot] = null
		update_inventory()
		print("Deleted item from slot", selected_slot)
		deselect_item()
		
func use_item():
	if selected_slot == null or inventory[selected_slot] == null:
		print("No item selected.")
		return
	
	var item = inventory[selected_slot]
	
	# Check if the item is a spell
	if item["type"] == ItemType.SPELL:
		var spell_name = item["name"]
		if spell_name in spell_messages:
			print_centered(spell_messages[spell_name])  # Show the message
			item["count"] -= 1  # Reduce stack by 1
			if item["count"] <= 0:
				inventory[selected_slot] = null  # Remove if no more left
			
			update_inventory()
		else:
			print("Unknown spell.")
	else:
		print_centered("NOT USABLE")
		print("NOT USABLE")  # Item is not a spell
	deselect_item()
		

func print_centered(message):
	message_label.text = message
	message_label.visible = true
	$CanvasLayer/Panel/Label/ColorRect.visible = true

	# Hide message after 2 seconds
	$CanvasLayer/Panel/Label.get_tree().create_timer(2).timeout.connect(func():
		message_label.visible = false
	)
	$CanvasLayer/Panel/Label/ColorRect.get_tree().create_timer(2).timeout.connect(func():
		$CanvasLayer/Panel/Label/ColorRect.visible = false
	)
	
func move_item_to_item_bar(slot_index, hud, bar_slot):
	if inventory[slot_index] != null:
		hud.move_to_item_bar(inventory[slot_index], bar_slot)  # Move to HUD
		inventory[slot_index] = null  # Remove from inventory
		selected_slot = null  # Clear selection
		update_inventory()

func move_item_to_potion_bar(slot_index, hud, bar_slot):
	if inventory[slot_index] != null and inventory[slot_index]["type"] == ItemType.SPELL:
		hud.move_to_potion_bar(inventory[slot_index], bar_slot)
		inventory[slot_index] = null
		selected_slot = null
		update_inventory()
	else:
		print("Only potions can go here!")
