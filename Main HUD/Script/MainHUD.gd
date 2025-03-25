# MainHUD.gd
# This script manages the plaers HUD( heads up display), handling the item bar and potion bar,
# as well as controlling potiona usage, and interactions with the inventory 
extends Control

# Call the required scene items
@onready var item_bar = $"CanvasLayer/Item Bar"
@onready var potion_bar = $"CanvasLayer/Potion Bar"
@onready var pinned_quest_container = $CanvasLayer/PinnedQuestContainer
@onready var quest_list = $CanvasLayer/PinnedQuestContainer/QuestList
@onready var background_panel = $CanvasLayer/PinnedQuestContainer/BackgroundPanel
@onready var potions_manager = preload("res://Main HUD/Script/potion.gd").new()


var battle_ui = null



var inventory
# Storage for HUD items
var item_bar_slots = [null, null, null, null, null]
var potion_bar_slots = [null, null]

# initilize the main hud along with the hot bars
func _ready():
	var hud_ready_time = Time.get_ticks_msec()
	var load_latency = hud_ready_time - SaveManager.game_start_time
	print("HUD Load Latency (ms): ", load_latency)

	setup_hotbars()
	QuestManager.pinned_quests_updated.connect(update_pinned_quests)
	update_pinned_quests(QuestManager.pinned_quests)  # Initial load if needed
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Connect Item Bar Slots to a function for clicking
	for i in range(item_bar.get_child_count()):
		var button = item_bar.get_child(i)
		button.connect("pressed", Callable(self, "hotbar_slot_clicked").bind(i))
	
	for i in range(potion_bar.get_child_count()):
		var button = potion_bar.get_child(i)
		button.connect("pressed", Callable(self, "hotbar_potion_slot_clicked").bind(i))
		
	


# Function to make sure inventory is a global call for main hud
func set_inventory(inv):
	inventory = inv
	
func save_potion_count():
	PlayerData.potion_bar = potion_bar_slots.duplicate(true)


# Function to make sure the item bar is set up correctly with sizing and nodes
func setup_hotbars():
	for i in range(item_bar.get_child_count()):
		var button = item_bar.get_child(i)
		setup_hotbar_button(button)

	# Ensure Potion Bar slots are set up correctly
	for i in range(potion_bar.get_child_count()):
		var button = potion_bar.get_child(i)
		setup_hotbar_button(button)

# Function to set fixed size for each button
func setup_hotbar_button(button):
	button.custom_minimum_size = Vector2(64, 64)
	button.set_size(Vector2(64, 64))
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	button.expand_icon = false
	button.set_anchors_preset(Control.PRESET_CENTER)
	button.size = Vector2(64, 64)
	

# When clicking an Item Bar slot, try moving the selected inventory item
func hotbar_slot_clicked(slot_index):
	if inventory == null:
		print("ERROR: Inventory not assigned to HUD!")
		return

	# Check if battle UI is active
	var in_battle = battle_ui != null and battle_ui.is_visible_in_tree()

	# If there's an item in the hotbar
	if item_bar_slots[slot_index] != null:
		if in_battle:
			handle_battle_attack(slot_index)
		else:
			move_from_hotbar_to_inventory(slot_index)

	# If inventory is open and slot is empty, allow moving item into hotbar
	elif inventory.selected_slot != null:
		var selected_item = inventory.get_selected_item()
		if selected_item["type"] == inventory.ItemType.SPELL:
			print("Potions cannot be placed in the Item Bar!")
			return
		inventory.move_item_to_item_bar(inventory.selected_slot, self, slot_index)




func hotbar_potion_slot_clicked(slot_index):
	if inventory == null:
		#DEBUG
		print("ERROR: Inventory not assigned to HUD!")
		return

	# If inventory is open, move potion as before
	if inventory.is_inventory_open():
		if potion_bar_slots[slot_index] != null:
			move_potion_from_hotbar_to_inventory(slot_index)
		elif inventory.selected_slot != null:
			var selected_item = inventory.get_selected_item()
			if selected_item["type"] == inventory.ItemType.ITEM:
				#DEBUG
				print("Items cannot be placed in the Potion Bar!")
				return
			inventory.move_item_to_potion_bar(inventory.selected_slot, self, slot_index)
		return
	use_potion_bar(slot_index)
	
#Function to be able to use items when we can
func use_item_bar(slot_index):
	if item_bar_slots[slot_index] != null:
		print("Used", item_bar_slots[slot_index]["name"])
		item_bar_slots[slot_index] = null
		item_bar.get_child(slot_index).icon = null

#Function if the inventoy is closed you can click potions on potion bar and will be used
func use_potion_bar(slot_index):
	# If inventory is closed, use the potion instead
	var item = potion_bar_slots[slot_index]
	if item == null:
		print("No potion in hotbar slot", slot_index)
		return  # No potion to use

	var potion_name = item["name"]

	# Handle Health Potion
	if potion_name == "Health Potion":  # Ensure the correct potion name
		var health_manager = get_node_or_null("CanvasLayer/Health_Bar")  # Adjust to match scene structure
		if potions_manager.use_health_potion(health_manager, item):
			remove_potion(slot_index)

	# Handle EXP Potion
	elif potion_name == "EXP Potion":  # Ensure the correct potion name
		var exp_manager = get_node_or_null("CanvasLayer/EXP_Bar")  # Ensure correct path to EXP system
		if potions_manager.use_exp_potion(exp_manager, item):
			remove_potion(slot_index)
	else:
		print("This is not a valid potion.")
	PlayerData.potion_bar = potion_bar_slots.duplicate(true)

	update_potion_display()
	
func remove_potion(slot_index):
	var item = potion_bar_slots[slot_index]
	if item["count"] > 1:
		item["count"] -= 1
	else:
		potion_bar_slots[slot_index] = null

#Function to check what type of potion is being added to the potion bar
func check_potion(item) -> bool:
	# Ensure the item is valid and is a potion
	if item == null or item["type"] != inventory.ItemType.SPELL:
		return false  # Not a potion, so let it be added normally

	var potion_name = item["name"]
	
	# Loop through potion bar slots
	for i in range(potion_bar_slots.size()):
		var slot = potion_bar_slots[i]
		
		# If the same potion is already in the slot, increment the count
		if slot != null and slot["name"] == potion_name:
			slot["count"] += item["count"]  # Increase the count
			update_potion_display()  # Update the UI to reflect changes
			return true  # Indicate that it was handled

	return false  # Potion was not in the hotbar, allow inventory to handle it

#Function to move items from item bar to inventory
func move_from_hotbar_to_inventory(slot_index):
	# Prevent moving items if in battle
	var in_battle = battle_ui != null and battle_ui.is_visible_in_tree()
	if in_battle:
		print("⚠️ Can't move items during battle.")
		return

	if inventory == null:
		print("ERROR: Inventory not assigned to HUD!")
		return

	if not inventory.is_inventory_open():
		print("Inventory is closed. Cannot move item.")
		return

	var item = item_bar_slots[slot_index]
	if item == null:
		print("No item in hotbar slot", slot_index)
		return

	if not inventory.has_space_for_item():
		print("Inventory full! Item remains in hotbar.")
		return

	item_bar_slots[slot_index] = null
	var button = item_bar.get_child(slot_index)
	button.icon = null

	var success = inventory.add_item_from_hotbar(item)
	if not success:
		print("Inventory full! Cannot move item from hotbar.")

	print("Moved", item["name"], "from hotbar slot", slot_index, "to inventory")


# Function to move potions from protion bar to inventory
func move_potion_from_hotbar_to_inventory(slot_index):
	if inventory == null:
		print("ERROR: Inventory not assigned to HUD!")
		return

	# Check if inventory is open
	if not inventory.is_inventory_open():
		print("Inventory is closed. Cannot move potion.")
		return

	var potion = potion_bar_slots[slot_index]
	if potion == null:
		print("No potion in hotbar slot", slot_index)
		return

	var potion_name = potion["name"]
	var potion_count = potion["count"]
	var potion_texture = potion["texture"]

	# Check if the inventory has space before removing the potion
	if not inventory.has_space_for_item():
		print("Inventory full! Potion remains in hotbar.")
		return 

	# Remove potion from potion bar
	potion_bar_slots[slot_index] = null
	var button = potion_bar.get_child(slot_index)
	button.icon = null
	button.text = ""

	# Add potion back to inventory with correct count and texture
	var success = inventory.add_potion_from_hotbar(potion_name, potion_count, potion_texture)
	if not success:
		print("Inventory full! Cannot move potion from hotbar.")
	
#	DEBUG
	print("Moved", potion_count, potion_name, "from potion hotbar slot", slot_index, "to inventory")

# Function to move an item from inventory to item bar
func move_to_item_bar(item, slot_index):
	if slot_index < item_bar_slots.size():
		item_bar_slots[slot_index] = item
		var button = item_bar.get_child(slot_index)
		# Set icon and prevent stretching
		button.icon = item["texture"]
		setup_hotbar_button(button)
		#Debug
		print("Moved", item["name"], "to Item Bar slot", slot_index)

# Function to move potion from inventory to portion bar
func move_to_potion_bar(item, slot_index):
	if slot_index < potion_bar_slots.size():
		var potion_name = item["name"]
		var potion_count = inventory.get_item_count(potion_name)  

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
					"texture": resize_texture(item["texture"], Vector2(64, 64)),
					"count": potion_count 
				}
			else:
				print("Potion slot is already occupied!")
				return
		
		# Remove from inventory since it's now in HUD
		inventory.remove_item(potion_name, potion_count)
		PlayerData.potion_bar = potion_bar_slots.duplicate(true)

		# Update button UI with locked icon size
		var button = potion_bar.get_child(slot_index)
		button.icon = resize_texture(item["texture"], Vector2(64, 64))  # Apply resized texture
		setup_hotbar_button(button)
		update_potion_display()

# Use a potion from the potion bar
func update_potion_display():
	for i in range(potion_bar_slots.size()):
		var button = potion_bar.get_child(i)
		if button is Button:
			if potion_bar_slots[i] != null:
				button.icon = resize_texture(potion_bar_slots[i]["texture"], Vector2(64, 64))
				button.expand_icon = false
				button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
				button.custom_minimum_size = Vector2(64, 64)
				button.set_size(Vector2(64, 64))
				
				# Display count only if > 1
				button.text = str(potion_bar_slots[i]["count"]) if potion_bar_slots[i]["count"] > 1 else ""
			else:
				button.icon = null
				button.text = ""

#Function to fix textures on the item and potion displays
func resize_texture(original_texture: Texture, size: Vector2) -> ImageTexture:
	var image = original_texture.get_image()
	image.resize(size.x, size.y, Image.INTERPOLATE_LANCZOS)
	var new_texture = ImageTexture.create_from_image(image)
	return new_texture
	
enum ItemType { ITEM, SPELL }

	
func restore_item_bar(slot_index: int, saved_item: Dictionary):
	var item_data = null
	
	if saved_item.is_empty() or not saved_item.has("name"):
		print("Skipping empty/invalid item bar slot", slot_index)
		return

	match saved_item["name"]:
		"Health Potion":
			item_data = {
				"type": inventory.ItemType.SPELL,
				"name": "Health Potion",
				"texture": resize_texture(preload("res://Inventory/assets/heal.png"), Vector2(64, 64)),
				"stackable": true,
				"count": saved_item["count"]
			}
		"Speed Potion":
			item_data = {
				"type": inventory.ItemType.SPELL,
				"name": "Speed Potion",
				"texture": resize_texture(preload("res://Inventory/assets/speed.png"), Vector2(64, 64)),
				"stackable": true,
				"count": saved_item["count"]
			}
		"EXP Potion":
			item_data = {
				"type": inventory.ItemType.SPELL,
				"name": "EXP Potion",
				"texture": resize_texture(preload("res://Inventory/assets/Experience.png"), Vector2(64, 64)),
				"stackable": true,
				"count": saved_item["count"]
			}
		"Pickaxe":
			item_data = {
				"type": inventory.ItemType.ITEM,
				"name": "Pickaxe",
				"texture": resize_texture(preload("res://Inventory/assets/Pickaxe.jpg"), Vector2(64, 64)),
				"stackable": false,
				"count": saved_item["count"]
			}
		"Axe":
			item_data = {
				"type": inventory.ItemType.ITEM,
				"name": "Axe",
				"texture": resize_texture(preload("res://Inventory/assets/Axe.png"), Vector2(64, 64)),
				"stackable": false,
				"count": saved_item["count"]
			}
		_:
			print("Unknown item in item bar:", saved_item["name"])
			return

	item_bar_slots[slot_index] = item_data
	var button = item_bar.get_child(slot_index)
	button.icon = item_data["texture"]
	button.tooltip_text = item_data["name"]
	setup_hotbar_button(button)
	print("Restored item to Item Bar:", item_data["name"], "at slot", slot_index)


func restore_potion_bar(slot_index: int, saved_potion: Dictionary):
	var potion_data = null
	
	if saved_potion.is_empty() or not saved_potion.has("name"):
		print("Skipping empty/invalid item bar slot", slot_index)
		return

	match saved_potion["name"]:
		"Health Potion":
			potion_data = {
				"type": inventory.ItemType.SPELL,
				"name": "Health Potion",
				"texture": resize_texture(preload("res://Inventory/assets/heal.png"), Vector2(64, 64)),
				"stackable": true,
				"count": saved_potion["count"]
			}
		"Speed Potion":
			potion_data = {
				"type": inventory.ItemType.SPELL,
				"name": "Speed Potion",
				"texture": resize_texture(preload("res://Inventory/assets/speed.png"), Vector2(64, 64)),
				"stackable": true,
				"count": saved_potion["count"]
			}
		"EXP Potion":
			potion_data = {
				"type": inventory.ItemType.SPELL,
				"name": "EXP Potion",
				"texture": resize_texture(preload("res://Inventory/assets/Experience.png"), Vector2(64, 64)),
				"stackable": true,
				"count": saved_potion["count"]
			}
		_:
			print("Unknown potion in potion bar:", saved_potion["name"])
			return

	potion_bar_slots[slot_index] = potion_data
	var button = potion_bar.get_child(slot_index)
	button.icon = potion_data["texture"]
	button.tooltip_text = potion_data["name"]
	setup_hotbar_button(button)
	update_potion_display()
	print("Restored potion to Potion Bar:", potion_data["name"], " at slot", slot_index)
	
func update_pinned_quests(pinned_quests: Array[Quest]):
	# Clear current labels
	for child in quest_list.get_children():
		child.queue_free()

	# Add labels for each pinned quest
	for quest in pinned_quests:
		var label = Label.new()
		label.text = quest.quest_name
		label.add_theme_color_override("font_color", Color(1, 1, 0))  # Yellow text
		quest_list.add_child(label)

	# Control visibility
	pinned_quest_container.visible = pinned_quests.size() > 0
	
func handle_battle_attack(slot_index):
	var item = item_bar_slots[slot_index]
	if item == null:
		return

	if battle_ui.turn_locked:
		print("Turn is locked. Wait for CPU.")
		return

	# Basic damage logic
	var base_damage = 5
	var miss_chance = randf() <= 0.05
	var crit_chance = randf() <= 0.10
	var break_chance = randf() <= 0.10

	if miss_chance:
		battle_ui.show_battle_message("You missed!")
		battle_ui.lock_turn()
		await get_tree().create_timer(2).timeout
		battle_ui.cpu_attack()
		return

	var final_damage = base_damage
	if crit_chance:
		final_damage = int(base_damage * 1.5)

	if break_chance:
		battle_ui.show_battle_message("%s broke!" % item["name"])
		item_bar_slots[slot_index] = null
		item_bar.get_child(slot_index).icon = null
	else:
		battle_ui.player_attack(final_damage)
		
func set_battle_ui(ui):
	battle_ui = ui
	print("✅ Battle UI manually set:", battle_ui.name)
