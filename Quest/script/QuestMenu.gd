extends Control

@onready var quest_list = $CanvasLayer/PanelContainer/HBoxContainer/QuestListContainer/ScrollContainer/QuestListContent
@onready var locked_quest_list = $CanvasLayer/PanelContainer/HBoxContainer/QuestListContainer/ScrollContainerLocked/QuestListContent
@onready var current_quest_label = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/CurrentQuestLabel
@onready var reward_preview = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/RewardPreview
@onready var complete_button = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/ButtonContainer/CompleteButton
@onready var close_button = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/ButtonContainer/CloseButton
@onready var pin_button = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/ButtonContainer/Pin
@onready var quest_list_container = $CanvasLayer/PanelContainer/HBoxContainer/QuestListContainer
@onready var quest_details_container = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer

var inventorymanager = null
var inventory = null
var current_quest = null

func _ready():
	quest_details_container.hide()
	complete_button.pressed.connect(on_complete_pressed)
	close_button.pressed.connect(on_close_pressed)
	update_quest()
	toggle_questmenu()

	inventorymanager = get_node("/root/InventoryManager")  # or however you load inventory
	QuestManager.quest_completed.connect(func(_name): update_quest())
	QuestManager.set_quest_menu(self)

	
	# Initial setup for pin button
	pin_button.pressed.connect(toggle_pin_current_quest)
	pin_button.visible = false  # Hide until a quest is selected


func update_quest():
	# Clear out old buttons
	for child in quest_list.get_children():
		child.queue_free()
	for child in locked_quest_list.get_children():
		child.queue_free()
	locked_quest_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	locked_quest_list.custom_minimum_size.x = 0

	# Fetch all quests
	var all_quests = QuestManager.get_all_quests()

	# Separate out available (can start) and locked quests
	var available_quests = []
	var locked_quests = []

	for quest in all_quests:
		if quest.is_completed:
			continue

		if QuestManager.can_start_quest(quest):
			available_quests.append(quest)
		else:
			locked_quests.append(quest)

	# Sort available quests: pinned ones go first
	available_quests.sort_custom(func(a, b):
		if a.pinned and !b.pinned:
			return true
		if !a.pinned and b.pinned:
			return false
		if a.priority != b.priority:
			return a.priority < b.priority
		return a.quest_name < b.quest_name
	)


	# Create UI for available quests (with Pin button)
	for quest in available_quests:
		var quest_button = Button.new()
		quest_button.text = quest.quest_name
		quest_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		quest_button.custom_minimum_size.y = 40
		quest_button.custom_minimum_size.x = 180  # Adjust width to fit your ScrollContainer

		quest_button.autowrap_mode = TextServer.AUTOWRAP_WORD  # ✅ Enables word wrapping
		quest_button.clip_text = false                          # ✅ Prevents text cutoff
		quest_button.text_overrun_behavior = TextServer.OVERRUN_TRIM_WORD_ELLIPSIS
		
		if QuestManager.ready_to_complete.has(quest.quest_name):
			quest_button.add_theme_color_override("font_color", Color(0, 1, 0))  # Green
			if !quest.pinned:
				QuestManager.pin_quest(quest)
		elif quest.pinned:
			if QuestManager.ready_to_complete.has(quest.quest_name):
				quest_button.add_theme_color_override("font_color", Color(0.4, 1.0, 0.4))  # Green if ready
			else:
				quest_button.add_theme_color_override("font_color", Color(1, 1, 0))  # Otherwise yellow



		if QuestManager.ready_to_complete.has(quest.quest_name):
			quest_button.add_theme_color_override("font_color", Color(0.4, 1.0, 0.4))  # Bright green
		elif quest.pinned:
			quest_button.add_theme_color_override("font_color", Color(1, 1, 0))  # Yellow

		quest_button.pressed.connect(func(): show_quest_details(quest, false))

		# Add Pin button inside an HBoxContainer
		var quest_entry = HBoxContainer.new()
		quest_entry.custom_minimum_size.y = 70  # Adds vertical space between entries
		quest_entry.add_child(quest_button)

		var pin_button = Button.new()
		pin_button.text = "📌" if quest.pinned else "Pin"
		pin_button.custom_minimum_size.x = 50
		pin_button.pressed.connect(func(): toggle_pin_quest(quest, pin_button, quest_button))
		quest_entry.add_child(pin_button)

		quest_list.add_child(quest_entry)

	# Create UI for locked quests (no Pin button here)
	# Create UI for locked quests (styled same as available, but no pin)
	for quest in locked_quests:
		var quest_button = Button.new()
		quest_button.text = quest.quest_name
		quest_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		quest_button.custom_minimum_size.y = 40
		quest_button.custom_minimum_size.x = 180

		# Wrapping and truncation behavior (same as available)
		quest_button.autowrap_mode = TextServer.AUTOWRAP_WORD
		quest_button.clip_text = false
		quest_button.text_overrun_behavior = TextServer.OVERRUN_TRIM_WORD_ELLIPSIS

		quest_button.pressed.connect(func(): show_quest_details(quest, true))

		# Add to an HBoxContainer to match layout
		var quest_entry = HBoxContainer.new()
		quest_entry.custom_minimum_size.y = 70  # Match spacing

		quest_entry.add_child(quest_button)

		# Add to locked list
		locked_quest_list.add_child(quest_entry)


func show_quest_details(quest, is_locked: bool):
	current_quest = quest
	print(QuestManager.ready_to_complete)
	if QuestManager.ready_to_complete.has(quest.quest_name) and QuestManager.ready_to_complete[quest.quest_name]:
		current_quest_label.text = quest.quest_name + " (Complete)"
		current_quest_label.add_theme_color_override("font_color", Color(0, 1, 0))  # Green
		if !quest.pinned:
			QuestManager.pin_quest(quest)
	else:
		current_quest_label.text = quest.quest_name
		current_quest_label.remove_theme_color_override("font_color")


	for child in reward_preview.get_children():
		child.queue_free()

	var description_label = Label.new()
	description_label.text = quest.description
	match quest.quest_name:
		"Movement Mastery: Walk All Ways":
			description_label.text = "Master movement by walking 30 steps in every direction:\n"
			description_label.text += "- Forward: %d / 30\n" % PlayerData.move_forward_count
			description_label.text += "- Backward: %d / 30\n" % PlayerData.move_backward_count
			description_label.text += "- Left: %d / 30\n" % PlayerData.move_left_count
			description_label.text += "- Right: %d / 30\n" % PlayerData.move_right_count

		"Campus Curiosity Part 2: The Library Tour":
			description_label.text = "Visit all five major Purdue libraries to gather research and Inspiration by Clicking each Building:\n"
			description_label.text += "- WALC (The Heart of Learning): %d/1\n" % int(PlayerData.visited_walc)
			description_label.text += "- Hicks Library (Science of Silence): %d/1\n" % int(PlayerData.visited_hicks)
			description_label.text += "- Armstrong Library (Archives of Armstrong): %d/1\n" % int(PlayerData.visited_armstrong)
			description_label.text += "- Lilly Library (Life Between the Shelves): %d/1\n" % int(PlayerData.visited_lilly)
			description_label.text += "- Vet Library (Feline Interference): %d/1\n" % int(PlayerData.visited_vet)

		"Campus Curiosity Part 1: Landmarks of Lore":
			description_label.text = "Explore iconic campus spots and uncover their lore:\n"
			description_label.text += "- Engineering Fountain (Waters of Wisdom): %d/1\n" % int(PlayerData.visited_fountain)
			description_label.text += "- Union Building (Find and then click the union): %d/1\n" % int(PlayerData.visited_union)
			description_label.text += "- Bell Tower (Timekeeper’s Toll): %d/1\n" % int(PlayerData.visited_belltower)
			description_label.text += "- Memorial Mall (Field of Futures): %d/1\n" % int(PlayerData.visited_mall)
			description_label.text += "- Lions Fountain: %d/1\n" % int(PlayerData.visited_corec)

		"Campus Curiosity Part 3: Professor’s Research":
			description_label.text = "Help recover the professor’s notes scattered around campus Find and then Click Each Building:\n"
			description_label.text += "- Lawson Building Entrance (Algorithms at Dawn): %d/1\n" % int(PlayerData.visited_cs)
			description_label.text += "- Physics Building (Energy Entanglement): %d/1\n" % int(PlayerData.visited_physics)
			description_label.text += "- Chemistry Building (Formula Fragments): %d/1\n" % int(PlayerData.visited_chemistry)
			description_label.text += "- Data Science and AI (Archives of the Computer): %d/1\n" % int(PlayerData.visited_hicks_notes)



	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	reward_preview.add_child(description_label)

	var rewards_label = Label.new()
	rewards_label.text = "Rewards:"
	reward_preview.add_child(rewards_label)
	

	for reward in quest.rewards:
		var item_name = reward.item_name
		var amount = reward.amount

		
		var reward_label = Label.new()
		reward_label.text = "- %s x%d" % [item_name, amount]
		reward_preview.add_child(reward_label)


	if is_locked:
		var prereq_label = Label.new()
		prereq_label.text = "\nPrerequisites:"
		reward_preview.add_child(prereq_label)
		

		for prereq_name in quest.prerequisites:
			var status = "❌"
			if QuestManager.is_quest_completed(prereq_name.quest_name):
				status = "✅"
			var prereq_line = Label.new()
			prereq_line.text = "- " + prereq_name.quest_name + " " + status
			reward_preview.add_child(prereq_line)

		complete_button.hide()
		pin_button.visible = false  # No pin for locked
	else:
		complete_button.show()
		
		# Only show complete button if the quest is marked as completed
		if quest.is_completed:
			complete_button.hide()
		elif QuestManager.ready_to_complete.has(quest.quest_name):
			complete_button.show()
		else:
			complete_button.hide()


		pin_button.visible = true
		pin_button.text = "Unpin" if quest.pinned else "Pin"

	quest_details_container.show()
	quest_list_container.custom_minimum_size.x = 250

func toggle_pin_current_quest():
	if current_quest == null:
		return

	if current_quest.pinned:
		QuestManager.unpin_quest(current_quest)
	else:
		QuestManager.pin_quest(current_quest)

	update_quest()  # Reorder list so pinned quests move to the top
	show_quest_details(current_quest, false)  # Refresh to update pin button text

func on_complete_pressed():
	if current_quest == null:
		return

	for reward in current_quest.rewards:
		var item_name = reward.item_name
		var amount = reward.amount

		for i in range(amount):
			if !inventory.add_named_item(item_name):
				prompt_inventory_full(item_name)
				return



	QuestManager.complete_quest(current_quest.quest_name)

	# Refresh after completing and hide details
	update_quest()
	close_quest_details()

func prompt_inventory_full(new_item):
	print("Inventory is full! Make room for: " + new_item)

func on_close_pressed():
	close_quest_details()

func close_quest_details():
	quest_details_container.hide()
	quest_list_container.custom_minimum_size.x = 250
	pin_button.visible = false  # Hide pin button when no quest is selected

func toggle_questmenu():
	$QuestMenuSFX.play()
	
	var panel = $CanvasLayer/PanelContainer
	panel.visible = !panel.visible

	if panel.visible:
		update_quest()
		close_quest_details()

func toggle_pin_quest(quest: Quest, pin_button: Button, quest_button: Button):
	if quest.pinned:
		QuestManager.unpin_quest(quest)
		pin_button.text = "Pin"
		quest_button.remove_theme_color_override("font_color")
	else:
		QuestManager.pin_quest(quest)
		pin_button.text = "Unpin"
		quest_button.add_theme_color_override("font_color", Color(1, 1, 0))

	update_quest()  # Refresh to reorder list if needed
	
func display_complete_button(quest: Quest):
	if current_quest != null and current_quest.quest_name == quest.quest_name:
		complete_button.show()
		
func get_item_texture(item_name: String) -> Texture:
	var item = ItemDefinitions.ITEM_DEFINITIONS.get(item_name, null)
	if item == null:
		item = ItemDefinitions.SPELL_DEFINITIONS.get(item_name, null)

	if item != null and item.has("texture_path"):
		return load(item["texture_path"])
	
	return null
