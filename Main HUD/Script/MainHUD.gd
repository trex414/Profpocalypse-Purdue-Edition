extends Control

# References to Item and Potion bars
@onready var item_bar = $"Item Bar"  # Ensure this matches your scene
@onready var potion_bar = $"Potion Bar"
var inventory


# Storage for HUD items
var item_bar_slots = [null, null, null, null, null]  # 5 item slots
var potion_bar_slots = [null, null]  # 2 potion slots (only potions)

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
		inventory.move_item_to_item_bar(inventory.selected_slot, self, slot_index)

func hotbar_potion_slot_clicked(slot_index):
	if inventory and inventory.selected_slot != null:
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
		if item["type"] == InventoryManager.ItemType.SPELL:  # Ensure only potions are placed
			potion_bar_slots[slot_index] = item
			var button = potion_bar.get_child(slot_index)
			
			# Set icon and prevent stretching
			button.icon = item["texture"]
			button.expand_icon = false  # Ensure icon does not stretch
			button.custom_minimum_size = Vector2(64, 64)  
			button.set_size(Vector2(64, 64))  
			print("Moved", item["name"], "to Potion Bar slot", slot_index)
		else:
			print("Only potions can be placed in the Potion Bar!")

# Use an item from the item bar
func use_item_bar(slot_index):
	if item_bar_slots[slot_index] != null:
		print("Used", item_bar_slots[slot_index]["name"])
		item_bar_slots[slot_index] = null  # Remove after use
		item_bar.get_child(slot_index).icon = null  # Clear icon

# Use a potion from the potion bar
func use_potion_bar(slot_index):
	if potion_bar_slots[slot_index] != null:
		print("Used potion:", potion_bar_slots[slot_index]["name"])
		potion_bar_slots[slot_index] = null  # Remove after use
		potion_bar.get_child(slot_index).icon = null  # Clear icon
