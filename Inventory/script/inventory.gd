# inventory.gd
# This script manages the inventory system, including adding, removing, selecting, 
# and using items. It also integrates with the HUD for potion usage.
extends Control

# Number of inventory slots
const SLOT_COUNT = 12
const COLUMNS = 3 
const ROWS = 4

# Slot container reference
@onready var grid_container = $CanvasLayer/Panel/GridContainer
@onready var backpack_bg = $CanvasLayer/Panel/BackpackBG
@onready var delete_button = $CanvasLayer/Panel/Delete
@onready var add_button = $"CanvasLayer/Panel/Add Item"
@onready var message_label = $CanvasLayer/Panel/Label
@onready var use_button = $"CanvasLayer/Panel/Use Usable"

# Variables
var main_hud = null 
var inventory = InventoryManager.inventory
# Inventory data structure
var selected_slot = null

# Item types
enum ItemType {ITEM , SPELL}
# create messages when used to call 
var spell_messages = {
	"HEAL": "You have been healed",
	"SPEED": "You are faster"
}

# Sample items (for testing)
var item_items = [
	{ "type": ItemType.ITEM, "name": "Pickaxe", "texture": resize_texture(preload("res://Inventory/assets/Pickaxe.jpg"), Vector2(64, 64)), "stackable": false, "count": 1 },
	{ "type": ItemType.ITEM, "name": "Axe", "texture": resize_texture(preload("res://Inventory/assets/Axe.png"), Vector2(64, 64)), "stackable": false, "count": 1 }
]

var spell_items = [
	{ "type": ItemType.SPELL, "name": "Health Potion", "texture": resize_texture(preload("res://Inventory/assets/heal.png"), Vector2(64, 64)), "stackable": true, "count": 1 },
	{ "type": ItemType.SPELL, "name": "Speed Potion", "texture": resize_texture(preload("res://Inventory/assets/speed.png"), Vector2(64, 64)), "stackable": true, "count": 1 },
	{ "type": ItemType.SPELL, "name": "EXP Potion", "texture": resize_texture(preload("res://Inventory/assets/Experience.png"), Vector2(64, 64)), "stackable": true, "count": 1 }

]

# Function to fix the sizing of the item images
func resize_texture(original_texture: Texture, size: Vector2) -> ImageTexture:
	var image = original_texture.get_image()
	image.resize(size.x, size.y, Image.INTERPOLATE_LANCZOS)  # High-quality resizing
	var new_texture = ImageTexture.create_from_image(image)
	return new_texture

# Inisilize 
func _ready():
	backpack_bg.texture = preload("res://Inventory/assets/Backpack.png")  # Load backpack image
	$CanvasLayer/Panel/Label/ColorRect.visible = false
	inventory = PlayerData.inventory.duplicate(true)
	setup_inventory()
	add_button.connect("pressed", Callable(self, "add_item"))
	delete_button.connect("pressed", Callable(self, "delete_item"))
	use_button.connect("pressed", Callable(self, "use_item"))
	toggle_inventory()

# Function to be able to global call main hud
func set_main_hud(hud):
	main_hud = hud

# Function Allows inventory to open and close
func toggle_inventory():
	var panel = $CanvasLayer/Panel
	panel.visible = !panel.visible
	deselect_item()

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
		slot.custom_minimum_size = Vector2(64, 64)
		slot.icon = preload("res://Inventory/assets/empty_slot1.png")
		slot.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot.expand_icon = true
		slot.connect("pressed", Callable(self, "select_item").bind(i))
		grid_container.add_child(slot)
		inventory.append(null)
	inventory = InventoryManager.inventory
	update_inventory()

# Function to add an item to the inventory
func add_item():
	# Randomly choose whether to add an ITEM or SPELL
	var category = randi() % 2  # 0 for ITEM, 1 for SPELL
	var new_item = null

	if category == 0:
		new_item = item_items[randi() % item_items.size()]
	else:
		new_item = spell_items[randi() % spell_items.size()]
		
	# if the item is in the hot bar it will be added there instead of inventory slot (potions)
	if main_hud != null and new_item["type"] == ItemType.SPELL and main_hud.check_potion(new_item):
		return
		
	# Adds new item to the inventory array in Player Data
	PlayerData.inventory = inventory.duplicate(true)
	
	print(PlayerData.get_game_state()) # Print for testing (confirm item is in inventory)

	# Try to stack if item is stackable
	if new_item["stackable"]:
		for i in range(SLOT_COUNT):
			if inventory[i] != null and inventory[i]["name"] == new_item["name"]:
				inventory[i]["count"] += 1
				
				PlayerData.inventory = inventory.duplicate(true)
				main_hud.save_potion_count()
				
				update_inventory()
				print("Stacked item in slot", i, "new count:", inventory[i]["count"])
				return
	
	# Find the first empty slot
	for i in range(SLOT_COUNT):
		if inventory[i] == null:
			inventory[i] = new_item.duplicate()
			
			PlayerData.inventory = inventory.duplicate(true)
			main_hud.save_potion_count()

			update_inventory()
			
			print("Added new item:", new_item["name"], "to slot", i)
			return
	
	print("Inventory full! Cannot add more items.")

# Function to update ui and reflect changes
func update_inventory():
	for i in range(SLOT_COUNT):
		var slot = grid_container.get_child(i)
		if slot is Button:
			if inventory[i] != null:
				slot.icon = inventory[i]["texture"]
				slot.expand_icon = true
				slot.text = str(inventory[i]["count"]) if inventory[i]["stackable"] else ""
			else:
				slot.icon = preload("res://Inventory/assets/empty_slot1.png")
				slot.text = ""

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
		
		PlayerData.inventory = inventory.duplicate(true)
		
		update_inventory()

	# Highlight selected slot (only if still selected)
	for i in range(SLOT_COUNT):
		var slot = grid_container.get_child(i)
		slot.modulate = Color(1, 1, 1, 1) if i != selected_slot else Color(1, 1, 0.5, 1)  

# Function to un-select a specific slot
func deselect_item():
	if selected_slot != null:
		# Reset all slots to default color
		for i in range(SLOT_COUNT):
			var slot = grid_container.get_child(i)
			slot.modulate = Color(1, 1, 1, 1)  

		selected_slot = null 
		update_inventory()  
	
	# Function to get selected item so we know the clicked item
func get_selected_item():
	if selected_slot != null and inventory[selected_slot] != null:
		return inventory[selected_slot]  # Return the actual item dictionary
	return null

# Function to get stackables count to move it or use it
func get_item_count(item_name):
	var count = 0
	for item in inventory:
		if item != null and item["name"] == item_name:
			count += item["count"]  
	return count

# Function to remove a specific amount of an item
func remove_item(item_name, amount):
	for i in range(SLOT_COUNT):
		if inventory[i] != null and inventory[i]["name"] == item_name:
			if inventory[i]["count"] > amount:
				inventory[i]["count"] -= amount
				return true 
			elif inventory[i]["count"] == amount:
				inventory[i] = null 
				return true
	return false
	
	PlayerData.inventory = inventory.duplicate(true)


# Function to delete selected item
func delete_item():
	if selected_slot != null and inventory[selected_slot] != null:
		inventory[selected_slot] = null
		
		PlayerData.inventory = inventory.duplicate(true)
		
		update_inventory()
		print("Deleted item from slot", selected_slot)
		deselect_item()

# Function to use potions ((NED to USE Potion.gd later)
func use_item():
	if selected_slot == null or inventory[selected_slot] == null:
		print("No item selected.")
		return
	
	var item = inventory[selected_slot]
	
	# Check if the item is a spell
	if item["type"] == ItemType.SPELL:
		var spell_name = item["name"]

		# If it's a HEAL potion, apply health recovery
		if spell_name == "Health Potion":
			if main_hud == null:
				print("ERROR: Main HUD reference is missing!")
				return

			var health_manager = main_hud.get_node_or_null("CanvasLayer/Health_Bar")  
			if health_manager != null:
				if health_manager.current_health < health_manager.max_health:
					health_manager.add_health(20)  
					print("Potion used! Health increased.")

					# Reduce potion count
					item["count"] -= 1
					if item["count"] <= 0:
						inventory[selected_slot] = null  

					PlayerData.inventory = inventory.duplicate(true)

					update_inventory() 
				else:
					print("Health is already full. Cannot use potion.")
			else:
				print("ERROR: HealthContainer node not found in HUD.")

		# EXP
		elif spell_name == "EXP Potion":
			if main_hud == null:
				print("ERROR: Main HUD reference is missing!")
				return

			var exp_manager = main_hud.get_node_or_null("CanvasLayer/EXP_Bar")  
			if exp_manager != null:
				exp_manager.add_exp(1) 
				print("EXP Potion used! Experience increased.")

				# Reduce potion count
				item["count"] -= 1
				if item["count"] <= 0:
					inventory[selected_slot] = null

					PlayerData.inventory = inventory.duplicate(true)

				update_inventory()
			else:
				print("ERROR: EXPContainer node not found in HUD.")

		# Handle other spells
		elif spell_name in spell_messages:
			print_centered(spell_messages[spell_name])
			item["count"] -= 1
			if item["count"] <= 0:
				inventory[selected_slot] = null
				
			PlayerData.inventory = inventory.duplicate(true)
			
			update_inventory()
		else:
			print("Unknown spell.")
	
	else:
		print_centered("NOT USABLE") # Item is not a spell
	
	deselect_item()

# Function print a message in the center of the inventory
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
	
# Function to move an item from inventory to the item bar
func move_item_to_item_bar(slot_index, hud, bar_slot):
	deselect_item()
	if inventory[slot_index] != null:
		hud.move_to_item_bar(inventory[slot_index], bar_slot)  # Move to HUD
		PlayerData.item_bar[bar_slot] = inventory[slot_index]
		inventory[slot_index] = null  # Remove from inventory
		selected_slot = null  # Clear selection
		
		PlayerData.inventory = inventory.duplicate(true)
		
		update_inventory()

# Function to move potion from inventory to potion bar
func move_item_to_potion_bar(slot_index, hud, bar_slot):
	deselect_item()
	if inventory[slot_index] != null and inventory[slot_index]["type"] == ItemType.SPELL:
		PlayerData.potion_bar[bar_slot] = inventory[slot_index]
		print("Added this potion to bar: ", inventory[slot_index])
		hud.move_to_potion_bar(inventory[slot_index], bar_slot)
		inventory[slot_index] = null
		selected_slot = null
		
		PlayerData.inventory = inventory.duplicate(true)
		
		update_inventory()
	else:
		print("Only potions can go here!")

# Function move item from item bar to inventory
func add_item_from_hotbar(item) -> bool:
	deselect_item()
	for i in range(SLOT_COUNT):
		if inventory[i] == null: 
			inventory[i] = item.duplicate()
			
			for j in range(PlayerData.item_bar.size()):
				if PlayerData.item_bar[j] == item:
					PlayerData.item_bar[j] = null
			
			PlayerData.inventory = inventory.duplicate()
			
			update_inventory()
			print("Added", item["name"], "to inventory slot", i)
			return true 
	return false

# Function move potion from potion bar to inventory
func add_potion_from_hotbar(potion_name, potion_count, potion_texture) -> bool:
	deselect_item()
	# Try to stack potion if it already exists in inventory
	for i in range(SLOT_COUNT):
		if inventory[i] != null and inventory[i]["name"] == potion_name:
			inventory[i]["count"] += potion_count
			
			for j in range(PlayerData.potion_bar.size()):
				if PlayerData.potion_bar[j].name == potion_name:
					if PlayerData.potion_bar[j].count > potion_count:
						PlayerData.potion_bar[j].count -= potion_count
					else:
						PlayerData.potion_bar[j] = null
			
			PlayerData.inventory = inventory.duplicate(true)
			
			update_inventory()
			print("Stacked", potion_count, potion_name, "in inventory slot", i)
			return true

	# Find the first empty slot
	for i in range(SLOT_COUNT):
		if inventory[i] == null:
			inventory[i] = {
				"type": ItemType.SPELL,
				"name": potion_name,
				"texture": potion_texture,  
				"stackable": true,
				"count": potion_count
			}
			for j in range(PlayerData.potion_bar.size()):
				if PlayerData.potion_bar[j] == null || PlayerData.potion_bar[j].is_empty():
					continue
				if PlayerData.potion_bar[j].name == potion_name:
					PlayerData.potion_bar[j] = null
			
			PlayerData.inventory = inventory.duplicate(true)
			
			update_inventory()
			print("Added new potion:", potion_name, "x", potion_count, "to slot", i)
			return true

	return false  

func is_inventory_open() -> bool:
	var panel = $CanvasLayer/Panel
	return panel.visible 
	
func has_space_for_item() -> bool:
	for i in range(SLOT_COUNT):
		if inventory[i] == null:
			return true  
	return false 
	
#
# TEST TO ADD ITEMS 
#
#
func add_named_item(item_name: String) -> bool:
	var item_data = null

	# Lookup table - match quest reward names to actual item definitions
	match item_name:
		"Health Potion":
			item_data = {
				"type": ItemType.SPELL,
				"name": "Health Potion",
				"texture": resize_texture(preload("res://Inventory/assets/heal.png"), Vector2(64, 64)),
				"stackable": true,
				"count": 1
			}
		"Speed Potion":
			item_data = {
				"type": ItemType.SPELL,
				"name": "Speed Potion",
				"texture": resize_texture(preload("res://Inventory/assets/speed.png"), Vector2(64, 64)),
				"stackable": true,
				"count": 1
			}
		"EXP Potion":
			item_data = {
				"type": ItemType.SPELL,
				"name": "EXP Potion",
				"texture": resize_texture(preload("res://Inventory/assets/Experience.png"), Vector2(64, 64)),
				"stackable": true,
				"count": 1
			}
		"Pickaxe":
			item_data = {
				"type": ItemType.ITEM,
				"name": "Pickaxe",
				"texture": resize_texture(preload("res://Inventory/assets/Pickaxe.jpg"), Vector2(64, 64)),
				"stackable": false,
				"count": 1
			}
		"Axe":
			item_data = {
				"type": ItemType.ITEM,
				"name": "Axe",
				"texture": resize_texture(preload("res://Inventory/assets/Axe.png"), Vector2(64, 64)),
				"stackable": false,
				"count": 1
			}
		_:
			update_inventory()
			print("Unknown item name:", item_name)
			return false

	# Handle potions going directly to the potion bar if there’s space
	if main_hud != null and item_data["type"] == ItemType.SPELL:
		if main_hud.check_potion(item_data):
			return true  # Added to potion bar, don't need to add to inventory

	# Try to stack if item already exists and is stackable
	if item_data["stackable"]:
		for i in range(SLOT_COUNT):
			if inventory[i] != null and inventory[i]["name"] == item_data["name"]:
				inventory[i]["count"] += 1
				
				PlayerData.inventory = inventory.duplicate(true)
				update_inventory()
				print("Stacked item:", item_data["name"], "new count:", inventory[i]["count"])
				return true

	# If no stack found, find first empty slot in inventory
	for i in range(SLOT_COUNT):
		if inventory[i] == null:
			inventory[i] = item_data.duplicate()
			
			PlayerData.inventory = inventory.duplicate(true)
			update_inventory()
			print("Added new item:", item_data["name"], "to slot", i)
			return true

	# --- NEW LOGIC ---
	# If inventory is full, check the item bar or potion bar (depending on type)
	if main_hud != null:
		if item_data["type"] == ItemType.SPELL:
			for j in range(PlayerData.potion_bar.size()):
				if PlayerData.potion_bar[j] == null:
					main_hud.move_to_potion_bar(item_data, j)
					print("Added to potion bar slot", j)
					return true
		elif item_data["type"] == ItemType.ITEM:
			for j in range(PlayerData.item_bar.size()):
				if PlayerData.item_bar[j] == null:
					main_hud.move_to_item_bar(item_data, j)
					print("Added to item bar slot", j)
					return true

	# If nothing worked, inventory AND hotbar are full
	print("Inventory and item/potion bars are full! Cannot add item:", item_data["name"])
	return false
	
func restore_item_at_slot(slot_index: int, saved_item: Dictionary):
	var item_data = null

	# Lookup table - match saved item names to full definitions
	match saved_item["name"]:
		"Health Potion":
			item_data = {
				"type": ItemType.SPELL,
				"name": "Health Potion",
				"texture": resize_texture(preload("res://Inventory/assets/heal.png"), Vector2(64, 64)),
				"stackable": true,
				"count": saved_item["count"]
			}
		"Speed Potion":
			item_data = {
				"type": ItemType.SPELL,
				"name": "Speed Potion",
				"texture": resize_texture(preload("res://Inventory/assets/speed.png"), Vector2(64, 64)),
				"stackable": true,
				"count": saved_item["count"]
			}
		"EXP Potion":
			item_data = {
				"type": ItemType.SPELL,
				"name": "EXP Potion",
				"texture": resize_texture(preload("res://Inventory/assets/Experience.png"), Vector2(64, 64)),
				"stackable": true,
				"count": saved_item["count"]
			}
		"Pickaxe":
			item_data = {
				"type": ItemType.ITEM,
				"name": "Pickaxe",
				"texture": resize_texture(preload("res://Inventory/assets/Pickaxe.jpg"), Vector2(64, 64)),
				"stackable": false,
				"count": saved_item["count"]
			}
		"Axe":
			item_data = {
				"type": ItemType.ITEM,
				"name": "Axe",
				"texture": resize_texture(preload("res://Inventory/assets/Axe.png"), Vector2(64, 64)),
				"stackable": false,
				"count": saved_item["count"]
			}
		_:
			print("Unknown item during restore:", saved_item["name"])
			return

	# Set in inventory
	inventory[slot_index] = item_data
	update_inventory()
