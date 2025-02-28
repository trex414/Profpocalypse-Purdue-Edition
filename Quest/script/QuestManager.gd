extends Node
const Quest = preload("res://Quest/script/Quest.gd")
var all_quests = {}  # quest_name -> Quest object
var completed_quests = []

#all Quests
var walk_forward_quest = load("res://Quest/assets/WalkForward.tres")
var walk_backwards_quest = load("res://Quest/assets/WalkBackwards.tres")
var open_inventory_quest = load("res://Quest/assets/OpenInventory.tres")
func _ready():
	# Load and register all quests here
	add_quest(walk_forward_quest)
	add_quest(open_inventory_quest)

func add_quest(quest: Quest):
	all_quests[quest.quest_name] = quest

func complete_quest(name: String):
	if all_quests.has(name):
		all_quests[name].is_completed = true
		completed_quests.append(name)

func can_start_quest(quest: Quest) -> bool:
	for prereq in quest.prerequisites:
		if prereq not in completed_quests:
			return false
	return true

func get_unlocked_quests():
	var unlocked = []
	for quest in all_quests.values():
		if !quest.is_completed and can_start_quest(quest):
			unlocked.append(quest)
	return unlocked
