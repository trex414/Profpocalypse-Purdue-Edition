extends Control

@onready var quest_list = $CanvasLayer/PanelContainer/HBoxContainer/QuestListContainer/ScrollContainer/QuestListContent
@onready var locked_quest_list = $CanvasLayer/PanelContainer/HBoxContainer/QuestListContainer/ScrollContainerLocked/QuestListContent

@onready var current_quest_label = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/CurrentQuestLabel
@onready var reward_preview = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/RewardPreview
@onready var complete_button = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/ButtonContainer/CompleteButton
@onready var close_button = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/ButtonContainer/CloseButton
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


func update_quest():
	# Clear out old buttons
	for child in quest_list.get_children():
		child.queue_free()
	for child in locked_quest_list.get_children():
		child.queue_free()

	var all_quests = QuestManager.get_all_quests()

	for quest in all_quests:
		if quest.is_completed:
			continue  # Skip completed quests entirely

		var quest_button = Button.new()
		quest_button.text = quest.quest_name
		quest_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		quest_button.custom_minimum_size.y = 40

		if QuestManager.can_start_quest(quest):
			# ✅ All prerequisites are completed, so this should be available
			quest_button.pressed.connect(func(): show_quest_details(quest, false))
			quest_list.add_child(quest_button)
		else:
			# ❌ Still locked (some prerequisites missing)
			quest_button.pressed.connect(func(): show_quest_details(quest, true))
			locked_quest_list.add_child(quest_button)



func show_quest_details(quest, is_locked: bool):
	current_quest = quest
	current_quest_label.text = quest.quest_name

	for child in reward_preview.get_children():
		child.queue_free()

	var description_label = Label.new()
	description_label.text = quest.description
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	reward_preview.add_child(description_label)

	var rewards_label = Label.new()
	rewards_label.text = "Rewards:"
	reward_preview.add_child(rewards_label)

	for item_name in quest.rewards:
		var reward_label = Label.new()
		reward_label.text = "- " + item_name
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
	else:
		complete_button.show()

	quest_details_container.show()
	quest_list_container.custom_minimum_size.x = 200


func on_complete_pressed():
	if current_quest == null:
		return

	for item_name in current_quest.rewards:
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
	quest_list_container.custom_minimum_size.x = 400

func toggle_questmenu():
	var panel = $CanvasLayer/PanelContainer
	panel.visible = !panel.visible

	if panel.visible:
		update_quest()
		close_quest_details()
		
