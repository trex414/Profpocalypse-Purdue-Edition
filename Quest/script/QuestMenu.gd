extends Control

@onready var quest_list = $CanvasLayer/PanelContainer/HBoxContainer/QuestListContainer/ScrollContainer/QuestListContent
@onready var current_quest_label = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/CurrentQuestLabel
@onready var reward_preview = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/RewardPreview
@onready var complete_button = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/ButtonContainer/CompleteButton
@onready var close_button = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer/ButtonContainer/CloseButton
@onready var quest_list_container = $CanvasLayer/PanelContainer/HBoxContainer/QuestListContainer
@onready var quest_details_container = $CanvasLayer/PanelContainer/HBoxContainer/QuestDetailsContainer


var current_quest = null

func _ready():
	quest_details_container.hide()
	complete_button.pressed.connect(on_complete_pressed)
	close_button.pressed.connect(on_close_pressed)
	update_quest()
	toggle_questmenu()

# Populate the quest list dynamically
func update_quest():
	for child in quest_list.get_children():
		child.queue_free()
	
	var unlocked_quests = QuestManager.get_unlocked_quests()
	for quest in unlocked_quests:
		var quest_button = Button.new()
		quest_button.text = quest.quest_name
		quest_button.pressed.connect(func(): show_quest_details(quest))
		quest_list.add_child(quest_button)

# Display quest details when selected

# Display quest rewards
func refresh_rewards(quest):
	for child in reward_preview.get_children():
		child.queue_free()

	for item_name in quest.rewards:
		var reward_label = Label.new()
		reward_label.text = "Reward: " + item_name
		reward_preview.add_child(reward_label)

# Completing a quest
func on_complete_pressed():
	if current_quest == null:
		return

	var inventory_manager = get_node("/root/InventoryManager")  # Adjust if needed
	for item in current_quest.rewards:
		if !inventory_manager.try_add_qeitem(item):
			prompt_inventory_full(item)
			return

	QuestManager.complete_quest(current_quest.quest_name)
	update_quest()

# Handle full inventory
func prompt_inventory_full(new_item):
	print("Inventory is full! Manage your inventory to make room for: " + new_item)



func show_quest_details(quest):
	current_quest = quest
	current_quest_label.text = quest.description
	refresh_rewards(quest)

	# Show details and shrink the quest list to make room.
	quest_details_container.show()
	quest_list_container.custom_minimum_size.x = 200  # Move list left (make narrower)
	
func close_quest_details():
	quest_details_container.hide()
	quest_list_container.custom_minimum_size.x = 400  # Move list back to center width

func on_close_pressed():
	close_quest_details()

	
func toggle_questmenu():
	var panel = $CanvasLayer/PanelContainer
	panel.visible = !panel.visible
	close_quest_details()

	# Update inventory UI when opening
	if panel.visible:
		update_quest()
		print("QuestMenu opened.")
	else:
		print("QuestMenu closed.")
