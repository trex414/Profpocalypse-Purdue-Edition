extends Control

# References to Item and Potion bars
@onready var item_bar = $"CanvasLayer/Item Bar"  # Ensure this matches your scene
@onready var potion_bar = $"CanvasLayer/Potion Bar"
var inventory


# Storage for HUD items
var item_bar_slots = [null, null, null, null, null]  # 5 item slots
var potion_bar_slots = [null, null]  # Only 2 potion slots
var potion_counts = {}  # Dictionary to track potion counts separately

func _ready():
	# Ensure nodes exist
	if not is_instance_valid(item_bar) or not is_instance_valid(potion_bar):
		print("Error: HUD item or potion bar is missing! Check node names in the scene.")
		return
	setup_hotbars()
	
	# Connect Item Bar Slots to a function for clicking
	for i in range(item_bar.get_child_count()):
		var button = item_bar.get_child(i)
		button.connect("pressed", Callable(self, "hotbar_slot_clicked").bind(i))
	
	for i in range(potion_bar.get_child_count()):
		var button = potion_bar.get_child(i)
		button.connect("pressed", Callable(self, "hotbar_potion_slot_clicked").bind(i))

func setup_hotbars():
	# Ensure Item Bar slots are set up correctly
	for i in range(item_bar.get_child_count()):
		var button = item_bar.get_child(i)
		
		# Ensure fixed size
		button.custom_minimum_size = Vector2(64, 64)  
		button.set_size(Vector2(64, 64))  
		button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER  
		button.size_flags_vertical = Control.SIZE_SHRINK_CENTER  
		button.expand_icon = false  # Prevent icon from stretching

		# Force size anchoring
		button.set_anchors_preset(Control.PRESET_CENTER)
		button.size = Vector2(64, 64)

	# Ensure Potion Bar slots are set up correctly
	for i in range(potion_bar.get_child_count()):
		var button = potion_bar.get_child(i)
		
		# Ensure fixed size
		button.custom_minimum_size = Vector2(64, 64)  
		button.set_size(Vector2(64, 64))  
		button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER  
		button.size_flags_vertical = Control.SIZE_SHRINK_CENTER  
		button.expand_icon = false  # Prevent icon from stretching

		# Force size anchoring
		button.set_anchors_preset(Control.PRESET_CENTER)
		button.size = Vector2(64, 64)
		print("Hotbars initialized with strictly fixed sizes.")
	
func set_inventory(inv):
	inventory = inv
	

# When clicking an Item Bar slot, try moving the selected inventory item
func hotbar_slot_clicked(slot_index):
	if inventory and inventory.selected_slot != null:
		var selected_item = inventory.get_selected_item()  # Now this returns item data, not an index
		if selected_item["type"] == inventory.ItemType.SPELL:
			print("Potions cannot be placed in the Item Bar!")
			return
		inventory.move_item_to_item_bar(inventory.selected_slot, self, slot_index)

func hotbar_potion_slot_clicked(slot_index):
	if inventory and inventory.selected_slot != null:
		var selected_item = inventory.get_selected_item()  # Now this returns item data, not an index
		if selected_item["type"] == inventory.ItemType.ITEM:
			print("Items cannot be placed in the Potion Bar!")
			return
		inventory.move_item_to_potion_bar(inventory.selected_slot, self, slot_index)

# Function to move an item from inventory to item bar
func move_to_item_bar(item, slot_index):
	if slot_index < item_bar_slots.size():
		item_bar_slots[slot_index] = item
		var button = item_bar.get_child(slot_index)
		
		# Set icon and prevent stretching
		button.icon = item["texture"]
		button.expand_icon = false  # Ensure icon does not stretch
		button.custom_minimum_size = Vector2(64, 64)  
		button.set_size(Vector2(64, 64))  
		print("Moved", item["name"], "to Item Bar slot", slot_index)

func move_to_potion_bar(item, slot_index):
	if slot_index < potion_bar_slots.size():
		var potion_name = item["name"]
		var potion_count = inventory.get_item_count(potion_name)  # Get count from InventoryManager

		if potion_count == 0:
			print("No potions available in inventory.")
			return

		# If slot already has the same potion, update the count
		if potion_bar_slots[slot_index] != null and potion_bar_slots[slot_index]["name"] == potion_name:
			potion_bar_slots[slot_index]["count"] += potion_count
		else:
			if potion_bar_slots[slot_index] == null:
				# Assign new potion with correct count
				potion_bar_slots[slot_index] = { 
					"name": potion_name, 
					"texture": resize_texture(item["texture"], Vector2(64, 64)),  # Resize here
					"count": potion_count 
				}
			else:
				print("Potion slot is already occupied!")
				return
		
		# Remove from inventory since it's now in HUD
		inventory.remove_item(potion_name, potion_count)

		# Update button UI with locked icon size
		var button = potion_bar.get_child(slot_index)
		button.icon = resize_texture(item["texture"], Vector2(64, 64))  # Apply resized texture
		button.expand_icon = false  # Prevent automatic scaling
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER  # Center the icon
		button.custom_minimum_size = Vector2(64, 64)  # Lock button size
		button.set_size(Vector2(64, 64))  # Lock size
		
		update_potion_display()

		
func resize_texture(original_texture: Texture, size: Vector2) -> ImageTexture:
	var image = original_texture.get_image()
	image.resize(size.x, size.y, Image.INTERPOLATE_LANCZOS)  # High-quality resizing
	var new_texture = ImageTexture.create_from_image(image)
	return new_texture




func use_potion_bar(slot_index):
	var item = potion_bar_slots[slot_index]
	if item != null:
		print("Used potion:", item["name"])

		# Reduce count
		if item["count"] > 1:
			item["count"] -= 1
		else:
			potion_bar_slots[slot_index] = null  # Remove if no more left
		update_potion_display()

# Use an item from the item bar
func use_item_bar(slot_index):
	if item_bar_slots[slot_index] != null:
		print("Used", item_bar_slots[slot_index]["name"])
		item_bar_slots[slot_index] = null  # Remove after use
		item_bar.get_child(slot_index).icon = null  # Clear icon

# Use a potion from the potion bar
func update_potion_display():
	for i in range(potion_bar_slots.size()):
		var button = potion_bar.get_child(i)  # Get the potion button
		if button is Button:  # Ensure it's a button before modifying
			if potion_bar_slots[i] != null:
				button.icon = resize_texture(potion_bar_slots[i]["texture"], Vector2(64, 64))  # Apply fixed-size texture
				button.expand_icon = false  # Prevent stretching
				button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER  # Keep icon centered
				button.custom_minimum_size = Vector2(64, 64)  # Keep button size
				button.set_size(Vector2(64, 64))  # Keep icon fixed
				
				# Display count only if > 1
				button.text = str(potion_bar_slots[i]["count"]) if potion_bar_slots[i]["count"] > 1 else ""
