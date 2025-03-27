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

const ITEM_DEFINITIONS = ItemDefinitions.ITEM_DEFINITIONS
const SPELL_DEFINITIONS = ItemDefinitions.SPELL_DEFINITIONS



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
		
	if PlayerData.item_bar:
		item_bar_slots = PlayerData.item_bar.duplicate(true)
		for i in range(item_bar_slots.size()):
			if item_bar_slots[i] != null:
				restore_item_bar(i, item_bar_slots[i])


		
	


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

	# Check if battle UI is visible
	print("Trey this", Global.in_battle)
	
	
	if item_bar_slots[slot_index] != null:
		# During battle, use weapon to attack
		if Global.in_battle and !inventory.is_inventory_open():
			handle_battle_attack(slot_index)
		else:
			move_from_hotbar_to_inventory(slot_index)
	elif inventory.selected_slot != null:
		# Move selected item from inventory to hotbar
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
	# Get the potion from the potion bar slot
	var item = potion_bar_slots[slot_index]
	if item == null:
		print("No potion in hotbar slot", slot_index)
		return  # No potion to use

	var potion_name = item["name"]
	var used = false
	
	# Apply the potion's effect based on its type
	if potion_name == "Health Potion":
		var health_manager = get_node_or_null("CanvasLayer/Health_Bar")
		used = potions_manager.use_health_potion(health_manager, item)
	elif potion_name == "EXP Potion":
		var exp_manager = get_node_or_null("CanvasLayer/EXP_Bar")
		used = potions_manager.use_exp_potion(exp_manager, item)
	else:
		print("This is not a valid potion.")
	
	# If the potion effect was successfully applied, update the potion bar
	if used:
		remove_potion(slot_index)
		PlayerData.potion_bar = potion_bar_slots.duplicate(true)
		update_potion_display()
		
		# If in battle and the turn isn't locked, lock the turn and trigger CPU attack
		if Global.in_battle and not battle_ui.turn_locked:
			inventory.get_node("CanvasLayer/Panel").visible = false
			await battle_ui.lock_turn()
			await battle_ui.show_battle_message("Used turn for potion.")
			await battle_ui.cpu_attack()

	
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

	if inventory == null:
		print("ERROR: Inventory not assigned to HUD!")
		return

	# Check if inventory is open
	if not inventory.is_inventory_open():
		print("Inventory is closed. Cannot move item.")
		return

	var item = item_bar_slots[slot_index]
	if item == null:
		print("No item in hotbar slot", slot_index)
		return

	# Check if the inventory has space before removing the item
	if not inventory.has_space_for_item():
		print("Inventory full! Item remains in hotbar.")
		return

	# Remove item from hotbar
	item_bar_slots[slot_index] = null
	var button = item_bar.get_child(slot_index)
	button.icon = null  # Clear the hotbar slot

	# Add item to inventory
	var success = inventory.add_item_from_hotbar(item)
	if not success:
		print("Inventory full! Cannot move item from hotbar.")
	#debug
	#print("Moved", item["name"], "from hotbar slot", slot_index, "to inventory")
	if Global.in_battle and not battle_ui.turn_locked:
		print("item to inven")
		inventory.get_node("CanvasLayer/Panel").visible = false
		await battle_ui.lock_turn()
		await battle_ui.show_battle_message("Used turn to assign item.")
		await battle_ui.cpu_attack()


# Function to move potions from protion bar to inventory
func move_potion_from_hotbar_to_inventory(slot_index):
	if inventory == null:
		print("ERROR: Inventory not assigned to HUD!")
		return

	# Ensure the inventory is open before moving the potion
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

	# Check if the inventory has space for the potion before removing it from the HUD
	if not inventory.has_space_for_item():
		print("Inventory full! Potion remains in hotbar.")
		return 

	# Remove the potion from the potion bar
	potion_bar_slots[slot_index] = null
	var button = potion_bar.get_child(slot_index)
	button.icon = null
	button.text = ""
	PlayerData.item_bar = item_bar_slots.duplicate(true)

	# Add the potion back to the inventory with the correct count and texture
	var success = inventory.add_potion_from_hotbar(potion_name, potion_count, potion_texture)
	if not success:
		print("Inventory full! Cannot move potion from hotbar.")

	#print("Moved", potion_count, potion_name, "from potion hotbar slot", slot_index, "to inventory")

	# If in battle and the turn isn't locked, hide the inventory panel, lock the turn, show a battle message, and trigger CPU attack
	if Global.in_battle and not battle_ui.turn_locked:
		inventory.get_node("CanvasLayer/Panel").visible = false
		await battle_ui.lock_turn()
		await battle_ui.show_battle_message("Used turn to move potion to inventory.")
		await battle_ui.cpu_attack()

# Function to move an item from inventory to item bar
func move_to_item_bar(item, slot_index):
	if slot_index < item_bar_slots.size():
		item_bar_slots[slot_index] = item
		var button = item_bar.get_child(slot_index)
		# Set icon and prevent stretching
		button.icon = item["texture"]
		setup_hotbar_button(button)
		PlayerData.item_bar = item_bar_slots.duplicate(true)
		
		#Debug
		#print("Moved", item["name"], "to Item Bar slot", slot_index)
		
		if Global.in_battle and not battle_ui.turn_locked:
			inventory.get_node("CanvasLayer/Panel").visible = false
			await battle_ui.lock_turn()
			await battle_ui.show_battle_message("Used turn to assign item.")
			await battle_ui.cpu_attack()


# Function to move potion from inventory to portion bar
func move_to_potion_bar(item, slot_index):
	if slot_index < potion_bar_slots.size():
		var potion_name = item["name"]
		var potion_count = inventory.get_item_count(potion_name)  

		if potion_count == 0:
			print("No potions available in inventory.")
			return

		# If the slot already has the same potion, update its count
		if potion_bar_slots[slot_index] != null and potion_bar_slots[slot_index]["name"] == potion_name:
			potion_bar_slots[slot_index]["count"] += potion_count
		else:
			if potion_bar_slots[slot_index] == null:
				# Assign a new potion entry with the correct count and a resized texture
				potion_bar_slots[slot_index] = { 
					"name": potion_name, 
					"texture": resize_texture(item["texture"], Vector2(64, 64)),
					"count": potion_count 
				}
			else:
				print("Potion slot is already occupied!")
				return
		
		# Remove the potion from the inventory since it's now placed on the HUD
		inventory.remove_item(potion_name, potion_count)
		PlayerData.potion_bar = potion_bar_slots.duplicate(true)

		# Update the potion bar button UI with the resized texture and correct settings
		var button = potion_bar.get_child(slot_index)
		button.icon = resize_texture(item["texture"], Vector2(64, 64))
		setup_hotbar_button(button)
		update_potion_display()

		# If in battle and the turn isn't locked, lock the turn and trigger CPU attack
		if Global.in_battle and not battle_ui.turn_locked:
			inventory.get_node("CanvasLayer/Panel").visible = false
			await battle_ui.lock_turn()
			await battle_ui.show_battle_message("Used turn to assign potion.")
			await battle_ui.cpu_attack()


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
	if saved_item.is_empty() or not saved_item.has("name"):
		print("Skipping empty/invalid item bar slot", slot_index)
		return

	var item_def = {}
	if ITEM_DEFINITIONS.has(saved_item["name"]):
		item_def = ITEM_DEFINITIONS[saved_item["name"]]
	elif SPELL_DEFINITIONS.has(saved_item["name"]):
		item_def = SPELL_DEFINITIONS[saved_item["name"]]
	else:
		print("Unknown item during restore:", saved_item["name"])
		return

	var loaded_texture = load(item_def["texture_path"])
	if loaded_texture == null:
		print("Error: Could not load texture at path:", item_def["texture_path"])
		return

	var item_data = item_def.duplicate(true)   # duplicate all keys
	item_data["texture"] = resize_texture(loaded_texture, Vector2(64, 64))
	item_data["count"] = saved_item["count"]      # override with saved count

	item_bar_slots[slot_index] = item_data
	PlayerData.item_bar = item_bar_slots.duplicate(true)
	
	var button = item_bar.get_child(slot_index)
	button.icon = item_data["texture"]
	button.tooltip_text = item_data["name"]
	setup_hotbar_button(button)
	print("Restored item to Item Bar:", item_data["name"], "at slot", slot_index)




func restore_potion_bar(slot_index: int, saved_potion: Dictionary):
	if saved_potion.is_empty() or not saved_potion.has("name"):
		print("Skipping empty/invalid item bar slot", slot_index)
		return

	var item_name = saved_potion["name"]
	var def = {}
	# Look up the potion definition in your shared dictionaries:
	if ITEM_DEFINITIONS.has(item_name):
		def = ITEM_DEFINITIONS[item_name]
	elif SPELL_DEFINITIONS.has(item_name):
		def = SPELL_DEFINITIONS[item_name]
	else:
		print("Unknown potion in potion bar:", item_name)
		return

	# Load the texture dynamically:
	var loaded_texture = load(def["texture_path"])
	if loaded_texture == null:
		print("Error: Could not load texture at path:", def["texture_path"])
		return

	# Duplicate the definition (deep copy) to get all stats:
	var potion_data = def.duplicate(true)
	potion_data["texture"] = resize_texture(loaded_texture, Vector2(64, 64))
	# Override the count with the saved value:
	potion_data["count"] = saved_potion["count"]

	potion_bar_slots[slot_index] = potion_data

	var button = potion_bar.get_child(slot_index)
	button.icon = potion_data["texture"]
	button.tooltip_text = potion_data["name"]
	setup_hotbar_button(button)
	update_potion_display()

	print("Restored potion to Potion Bar:", potion_data["name"], "at slot", slot_index)


	
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

	# Pull stats from the item dictionary, using defaults if missing
	var base_damage  = item.get("damage", 1)
	var miss_rate    = item.get("miss_chance", 0.00)
	var crit_rate    = item.get("crit_chance", 0.0)
	var break_rate   = item.get("break_chance", 0.0)
	var stun_rate    = item.get("stun_chance", 0.0)  # If you want a stun effect

	# Evaluate random events
	var miss_chance = randf() <= miss_rate
	var crit_chance = randf() <= crit_rate
	var break_chance = randf() <= break_rate
	var stun_chance = randf() <= stun_rate

	if miss_chance:
		await battle_ui.lock_turn()
		await battle_ui.show_battle_message("You missed!")
		await get_tree().create_timer(2).timeout
		await battle_ui.cpu_attack()
		return

	var final_damage = base_damage
	if crit_chance:
		final_damage = int(base_damage * 1.5)

	if break_chance:
		await battle_ui.lock_turn()
		await battle_ui.show_battle_message("%s broke!" % item["name"])
		item_bar_slots[slot_index] = null
		item_bar.get_child(slot_index).icon = null
		await get_tree().create_timer(2).timeout
		await battle_ui.cpu_attack()
		return
	else:
		# Optionally handle stun
		if stun_chance:
			await battle_ui.lock_turn()
			await battle_ui.show_battle_message("You stunned the enemy!")
			# e.g. battle_ui.apply_stun_to_enemy() if you have that logic
			await get_tree().create_timer(2).timeout
			await battle_ui.cpu_attack()
			return

		# Otherwise do normal damage
		battle_ui.player_attack(final_damage)

		
func set_battle_ui(ui):
	battle_ui = ui
	print("✅ Battle UI manually set:", battle_ui.name)
