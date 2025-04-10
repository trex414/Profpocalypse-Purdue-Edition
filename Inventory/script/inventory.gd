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
@onready var info_panel = $"CanvasLayer/Info panel"  # Or the correct path to your InfoPanel node.
@onready var info_button = $"CanvasLayer/Panel/Info"
@onready var item_popup = $CanvasLayer/ItemPopupPanel
@onready var item_list_container = $CanvasLayer/ItemPopupPanel/ItemScroll/VBoxContainer

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

const ITEM_DEFINITIONS = ItemDefinitions.ITEM_DEFINITIONS
const SPELL_DEFINITIONS = ItemDefinitions.SPELL_DEFINITIONS


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
	add_button.connect("pressed", Callable(self, "open_item_selector"))

	delete_button.connect("pressed", Callable(self, "delete_item"))
	use_button.connect("pressed", Callable(self, "use_item"))
	info_button.connect("pressed", Callable(self, "on_info_pressed"))
	toggle_inventory()
	add_to_group("Inventory")
	info_panel.visible = false

# Function to be able to global call main hud
func set_main_hud(hud):
	main_hud = hud

# Function Allows inventory to open and close
func toggle_inventory():
	var panel = $CanvasLayer/Panel
	panel.visible = !panel.visible
	$InventorySFX.play()
	deselect_item()

	if panel.visible:
		update_inventory()
		print("Inventory opened.")
	else:
		print("Inventory closed.")
		info_panel.visible = false  # Ensure the info panel is hidden when the inventory is closed.
		item_popup.hide()


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
		slot.connect("gui_input", Callable(self, "_on_slot_gui_input").bind(i))
		grid_container.add_child(slot)
		inventory.append(null)
	inventory = InventoryManager.inventory
	update_inventory()

# Function to add an item to the inventory
func add_item():
	# Randomly choose whether to add an ITEM or SPELL.
	var category = randi() % 2  # 0 for item, 1 for spell.
	var new_item_name = ""
	if category == 0:
		var keys = ITEM_DEFINITIONS.keys()
		new_item_name = keys[randi() % keys.size()]
	else:
		var keys = SPELL_DEFINITIONS.keys()
		new_item_name = keys[randi() % keys.size()]
	
	# This function will create the item data and insert it into inventory or the hotbar.
	add_named_item(new_item_name)


# Function to update ui and reflect changes
func update_inventory():
	for i in range(SLOT_COUNT):
		var slot = grid_container.get_child(i)
		if slot is Button:
			if inventory[i] != null and inventory[i].has("texture"):
				slot.icon = inventory[i]["texture"]
				slot.expand_icon = true
				slot.text = str(inventory[i]["count"]) if inventory[i].has("stackable") and inventory[i]["stackable"] else ""
			else:
				slot.icon = preload("res://Inventory/assets/empty_slot1.png")
				slot.text = ""


# Function to select an item slot
func select_item(slot_index):
	if selected_slot == null:
		if inventory[slot_index] != null:
			selected_slot = slot_index
			print("Picked up item from slot:", slot_index)
			# If you want the info panel to update automatically:
			info_panel.update_info(inventory[slot_index])
			info_panel.visible = false
		# (Your code here for double-checking and picking up the item)
	else:
		if selected_slot != slot_index:
			var temp = inventory[slot_index]
			inventory[slot_index] = inventory[selected_slot]
			inventory[selected_slot] = temp
			print("Moved item from slot", selected_slot, "to slot", slot_index)
		selected_slot = null
		PlayerData.inventory = inventory.duplicate(true)
		update_inventory()
		
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
	var used = false

	# Only proceed if it's a spell/potion
	if item["type"] == ItemType.SPELL:
		var spell_name = item["name"]

		# 1) Fetch any dictionary-based stats you need (with a fallback):
		var heal_amount = item.get("heal_amount", 0)
		var exp_amount  = item.get("exp_amount", 0)
		# You can add more, e.g. speed_boost, etc.

		if item.has("heal_amount"):
			if main_hud == null:
				print("ERROR: Main HUD reference is missing!")
				return

			var health_manager = main_hud.get_node_or_null("CanvasLayer/Health_Bar")
			if health_manager != null:
				# Use heal_amount from the dictionary (defaulting to 0 if not found).
				if health_manager.current_health < health_manager.max_health:
					health_manager.add_health(heal_amount)
					print("Potion used! Health increased by %d." % heal_amount)
					item["count"] -= 1
					if item["count"] <= 0:
						inventory[selected_slot] = null
					PlayerData.inventory = inventory.duplicate(true)
					update_inventory()
					used = true
				else:
					print("Health is already full. Cannot use potion.")
			else:
				print("ERROR: HealthContainer node not found in HUD.")

		elif item.has("exp_amount"):
			if main_hud == null:
				print("ERROR: Main HUD reference is missing!")
				return

			var exp_manager = main_hud.get_node_or_null("CanvasLayer/EXP_Bar")
			if exp_manager != null:
				# Use exp_amount from the dictionary.
				exp_manager.add_exp(exp_amount)
				print("EXP Potion used! Gained %d EXP." % exp_amount)
				item["count"] -= 1
				if item["count"] <= 0:
					inventory[selected_slot] = null
				PlayerData.inventory = inventory.duplicate(true)
				update_inventory()
				used = true
			else:
				print("ERROR: EXPContainer node not found in HUD.")
				
		elif item.has("speed_boost"):
			var player = get_node("/root/TestMain/Map/TemporaryPlayer")
			if player != null:
				player.apply_speed_boost(item["speed_boost"], 30.0)
				print("Speed potion used! Boosted by %d." % item["speed_boost"])
				item["count"] -= 1
				if item["count"] <= 0:
					inventory[selected_slot] = null
				PlayerData.inventory = inventory.duplicate(true)
				update_inventory()
				used = true
			else:
				print("ERROR: Player node not found.")
				
		elif item.has("damage_amount"):
			if not Global.in_battle:
				print_centered("Can only use this in battle!")
				return

			if main_hud == null or main_hud.battle_ui == null:
				print("Battle UI not available.")
				return

			var damage = item["damage_amount"]
			print("💥 Used Legendary Damage Potion for", damage, "damage!")
			
			item["count"] -= 1
			if item["count"] <= 0:
				inventory[selected_slot] = null
			info_panel.visible = false

			main_hud.battle_ui.enemy_bar.take_damage(damage)
			main_hud.battle_ui.show_battle_message("You used a Legendary Damage Potion!")

			PlayerData.inventory = inventory.duplicate(true)
			update_inventory()
			used = true
					

		# If you have more potions, either check for them by name or rely on other keys:
		elif spell_name in spell_messages:
			# This is your existing message-based approach:
			print_centered(spell_messages[spell_name])
			item["count"] -= 1
			if item["count"] <= 0:
				inventory[selected_slot] = null
			PlayerData.inventory = inventory.duplicate(true)
			update_inventory()
			used = true
		else:
			print("Unknown spell.")
	else:
		print_centered("NOT USABLE")  # It's not a spell/potion

	# If a potion was used and you're in battle, lock the turn and trigger CPU attack
	if used and Global.in_battle and main_hud != null and main_hud.battle_ui and not main_hud.battle_ui.turn_locked:
		var panel = $CanvasLayer/Panel
		panel.visible = false
		await main_hud.battle_ui.lock_turn()
		await main_hud.battle_ui.show_battle_message("Used turn for potion.")
		$SpellSFX.play()
		await main_hud.battle_ui.cpu_attack()

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
	$WeaponSFX.play()
	deselect_item()
	if inventory[slot_index] != null and inventory[slot_index]["type"] == 0:
		PlayerData.item_bar[bar_slot] = inventory[slot_index]
		print("Added this weapon to bar: ", inventory[slot_index])
		hud.move_to_item_bar(inventory[slot_index], bar_slot)
		inventory[slot_index] = null
		selected_slot = null
		
		PlayerData.inventory = inventory.duplicate(true)
		
		update_inventory()
	else:
		print("Only weapons can go here!")



# Function to move potion from inventory to potion bar
func move_item_to_potion_bar(slot_index, hud, bar_slot):
	$SpellSFX.play()
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
	$WeaponSFX.play()
	deselect_item()
	for i in range(SLOT_COUNT):
		if inventory[i] == null: 
			inventory[i] = item.duplicate()
			
			for j in range(PlayerData.item_bar.size()):
				if PlayerData.item_bar[j] == item:
					PlayerData.item_bar[j] = null
			
			PlayerData.inventory = inventory.duplicate()
			
			update_inventory()
			if item.has("name"):
				print("Added", item["name"], "to inventory slot", i)
			else:
				print("⚠️ Item missing 'name' key when adding to inventory slot", i, "Item:", item)

			return true 
	return false

# Function move potion from potion bar to inventory
func add_potion_from_hotbar(item: Dictionary) -> bool:
	$SpellSFX.play()
	deselect_item()
	
	# Try stacking the potion if it already exists in the inventory.
	for i in range(SLOT_COUNT):
		if inventory[i] != null and inventory[i]["name"] == item["name"]:
			inventory[i]["count"] += item["count"]
			# Also update the global potion bar data to remove the used amount.
			for j in range(PlayerData.potion_bar.size()):
				if PlayerData.potion_bar[j] != null and PlayerData.potion_bar[j]["name"] == item["name"]:
					if PlayerData.potion_bar[j]["count"] > item["count"]:
						PlayerData.potion_bar[j]["count"] -= item["count"]
					else:
						PlayerData.potion_bar[j] = null
			PlayerData.inventory = inventory.duplicate(true)
			update_inventory()
			print("Stacked", item["count"], item["name"], "in inventory slot", i)
			return true

	# Find the first empty slot in the inventory.
	for i in range(SLOT_COUNT):
		if inventory[i] == null:
			# Duplicate the full potion object so that all properties (heal_amount, etc.) are preserved.
			inventory[i] = item.duplicate(true)
			PlayerData.inventory = inventory.duplicate(true)
			update_inventory()
			print("Added new potion:", item["name"], "x", item["count"], "to slot", i)
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
	var def = {}
	# Check in the two dictionaries
	if ITEM_DEFINITIONS.has(item_name):
		def = ITEM_DEFINITIONS[item_name]
		$WeaponSFX.play()
	elif SPELL_DEFINITIONS.has(item_name):
		def = SPELL_DEFINITIONS[item_name]
		$SpellSFX.play()
	else:
		update_inventory()
		print("Unknown item name:", item_name)
		return false
	
	# Create the base item_data using the common properties.
	var loaded_texture = load(def["texture_path"])
	if loaded_texture == null:
		print("Error: Could not load texture at path: ", def["texture_path"])
		return false  # or handle error accordingly

	var item_data = def.duplicate(true)  # duplicate all keys from the definition
	item_data["texture"] = resize_texture(loaded_texture, Vector2(64, 64))
	item_data["count"] = def["count"]  # set initial count
	
	# If the item is a spell and can be directly added to the HUD, do that.
	if main_hud != null and item_data["type"] == ItemType.SPELL:
		if main_hud.check_potion(item_data):
			return true
	
	# Try stacking if the item is stackable.
	if item_data["stackable"]:
		for i in range(SLOT_COUNT):
			if inventory[i] != null and inventory[i]["name"] == item_data["name"]:
				inventory[i]["count"] += 1
				PlayerData.inventory = inventory.duplicate(true)
				update_inventory()
				print("Stacked item:", item_data["name"], "new count:", inventory[i]["count"])
				return true
	
	# Otherwise, find the first empty slot.
	for i in range(SLOT_COUNT):
		if inventory[i] == null:
			inventory[i] = item_data.duplicate()
			PlayerData.inventory = inventory.duplicate(true)
			update_inventory()
			print("Added new item:", item_data["name"], "to slot", i)
			return true
	
	# If the inventory is full, try adding to the hotbar.
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
	
	print("Inventory and item/potion bars are full! Cannot add item:", item_data["name"])
	return false

	
func restore_item_at_slot(slot_index: int, saved_item: Dictionary):
	var item_def = {}
	# Look up the definition from the dictionaries.
	if ITEM_DEFINITIONS.has(saved_item["name"]):
		item_def = ITEM_DEFINITIONS[saved_item["name"]]
	elif SPELL_DEFINITIONS.has(saved_item["name"]):
		item_def = SPELL_DEFINITIONS[saved_item["name"]]
	else:
		print("Unknown item during restore:", saved_item["name"])
		return
	
	var loaded_texture = load(item_def["texture_path"])  # load at runtime
	if loaded_texture == null:
		print("Error: Could not load texture at path: ", item_def["texture_path"])
	# You can return or handle this error as you see fit

	var item_data = {
		"type": item_def["type"],
		"name": item_def["name"],
		"texture": resize_texture(loaded_texture, Vector2(64, 64)),
		"stackable": item_def["stackable"],
		"count": item_def["count"]
	}
	
	# Merge in any extra keys from the definition.
	for key in item_def.keys():
		if not item_data.has(key) and key != "texture_path":
			item_data[key] = item_def[key]
	
	# Set this restored item in the inventory.
	inventory[slot_index] = item_data
	update_inventory()
	
	
func drop_selected_item(slot_index: int):
	if inventory[slot_index] == null:
		return

	var item = inventory[slot_index]
	inventory[slot_index] = null
	PlayerData.inventory = inventory.duplicate(true)
	update_inventory()
	deselect_item()

	var player = get_node("/root/TestMain/Map/TemporaryPlayer")
	print("Player found at:", player.name, "Position:", player.global_position)
	var world = get_tree().get_root().get_node("TestMain")
	if world and world.has_method("drop_item_on_floor"):
		world.drop_item_on_floor(item["name"], player.global_position)

func _on_slot_gui_input(event: InputEvent, slot_index: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		print("Right-clicked slot", slot_index)
		drop_selected_item(slot_index)
		
func on_info_pressed():
	if selected_slot != null and inventory[selected_slot] != null:
		var item = inventory[selected_slot]
		info_panel.update_info(item)
		info_panel.visible = true
		deselect_item()
		print("Showing info for", item["name"])
	else:
		print("No item selected for info.")
		info_panel.visible = false
		deselect_item()
		
func open_item_selector():
	if item_popup.visible:
		item_popup.hide()
		return

	for child in item_list_container.get_children():
		child.queue_free()

	var all_items = ITEM_DEFINITIONS.keys() + SPELL_DEFINITIONS.keys()
	for item_name in all_items:
		var button = HBoxContainer.new()

		var icon_texture = load(ITEM_DEFINITIONS.get(item_name, {}).get("texture_path", SPELL_DEFINITIONS.get(item_name, {}).get("texture_path", "")))
		var texture_rect = TextureRect.new()
		texture_rect.texture = icon_texture
		texture_rect.custom_minimum_size = Vector2(20, 20)
		texture_rect.expand = true
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

		var label = Label.new()
		label.text = item_name

		# Optional spacing for cleaner layout
		label.add_theme_constant_override("margin_left", 6)

		# Color name by rarity
		var rarity = ITEM_DEFINITIONS.get(item_name, {}).get("rarity", SPELL_DEFINITIONS.get(item_name, {}).get("rarity", ""))
		match rarity:
			"common": label.add_theme_color_override("font_color", Color.WHITE)
			"rare": label.add_theme_color_override("font_color", Color(0.3, 0.6, 1.0))  # Light blue
			"epic": label.add_theme_color_override("font_color", Color(0.6, 0.2, 0.8))  # Purple
			"legendary": label.add_theme_color_override("font_color", Color(1.0, 0.7, 0.1))  # Gold

		button.add_child(texture_rect)
		button.add_child(label)
		button.mouse_filter = Control.MOUSE_FILTER_STOP
		button.connect("gui_input", Callable(self, "_on_item_gui_input").bind(item_name))
		item_list_container.add_child(button)

	item_popup.popup_centered()





	
func _on_item_selected(item_name: String):
	item_popup.hide()
	add_named_item(item_name)
	
func _on_item_gui_input(event: InputEvent, item_name: String):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_item_selected(item_name)

	
