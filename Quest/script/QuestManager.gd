extends Node
const Quest = preload("res://Quest/script/Quest.gd")
var all_quests = {}  # quest_name -> Quest object
var completed_quests = []

#all Quests
var walk_forward_quest = load("res://Quest/assets/WalkForward.tres")
var walk_backwards_quest = load("res://Quest/assets/WalkBackwards.tres")
var open_inventory_quest = load("res://Quest/assets/OpenInventory.tres")

func _ready():
	all_quests = PlayerData.current_quests
	completed_quests = PlayerData.completed_quests
	print("Beginning Completed Quests: ", PlayerData.completed_quests)
	
	# Load and register all quests here
	add_quest(walk_forward_quest)
	add_quest(open_inventory_quest)
	add_quest(walk_backwards_quest)


func add_quest(quest: Quest):
	all_quests[quest.quest_name] = quest

signal quest_completed(quest_name: String)

func complete_quest(name: String):
	if all_quests.has(name):
		all_quests[name].is_completed = true
		if name not in completed_quests:
			completed_quests.append(name)

		quest_completed.emit(name)
		
		PlayerData.completed_quests = completed_quests.duplicate(true)

		# Unlock any quests that depended on this one
		for quest in all_quests.values():
			if quest.is_completed:
				continue
			if quest in get_unlocked_quests():
				continue  # Already unlocked

			if can_start_quest(quest):
				print("✅ Unlocked quest:", quest.quest_name)
				
			PlayerData.current_quests[quest.quest_name] = quest



func can_start_quest(quest: Quest) -> bool:
	for prereq in quest.prerequisites:
		if prereq.quest_name not in completed_quests:
			return false
	return true



func get_unlocked_quests():
	var unlocked = []
	for quest in all_quests.values():
		if !quest.is_completed and can_start_quest(quest):
			unlocked.append(quest)
	return unlocked
	
func get_all_quests() -> Array:
	return all_quests.values()

func is_quest_completed(name: String) -> bool:
	return name in completed_quests
