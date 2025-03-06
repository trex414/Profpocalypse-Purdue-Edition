extends Node
const Quest = preload("res://Quest/script/Quest.gd")
var all_quests = {}  # quest_name -> Quest object
var completed_quests = []

var available_quests: Array[Quest] = []
var pinned_quests: Array[Quest] = []

#all Quests
var walk_forward_quest = load("res://Quest/assets/WalkForward.tres")
var walk_backwards_quest = load("res://Quest/assets/WalkBackwards.tres")
var open_inventory_quest = load("res://Quest/assets/OpenInventory.tres")
var walk_left_quest = load("res://Quest/assets/Walkleft.tres")

signal pinned_quests_updated(pinned_quests: Array[Quest])


func _ready():
	all_quests = PlayerData.current_quests
	completed_quests = PlayerData.completed_quests
	print("Beginning Completed Quests: ", PlayerData.completed_quests)
	
	# Load and register all quests here
	add_quest(walk_forward_quest)
	add_quest(open_inventory_quest)
	add_quest(walk_backwards_quest)
	add_quest(walk_left_quest)
	
	for quest in all_quests.values():
		if quest.quest_name in PlayerData.completed_quests:
			quest.is_completed = true
			
	for quest in all_quests.values():
		if quest.quest_name in PlayerData.pinned_quests and quest.quest_name not in PlayerData.completed_quests:
			quest.pinned = true
			pinned_quests.append(quest)



func add_quest(quest: Quest):
	all_quests[quest.quest_name] = quest

signal quest_completed(quest_name: String)

func complete_quest(name: String):
	if all_quests.has(name):
		var quest1 = all_quests[name]
		all_quests[name].is_completed = true
		if name not in completed_quests:
			completed_quests.append(name)
		if quest1.pinned:
			unpin_quest(quest1)
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
	

func pin_quest(quest: Quest):
	if !quest.pinned:
		quest.pinned = true
		pinned_quests.append(quest)
		if quest.quest_name not in PlayerData.pinned_quests:
			PlayerData.pinned_quests.append(quest.quest_name)
		pinned_quests_updated.emit(pinned_quests)  # Notify HUD

func unpin_quest(quest: Quest):
	if quest.pinned:
		quest.pinned = false
		pinned_quests.erase(quest)
		if quest.quest_name not in PlayerData.pinned_quests:
			PlayerData.pinned_quests.append(quest.quest_name)
		pinned_quests_updated.emit(pinned_quests)  # Notify HUD


func get_sorted_quests() -> Array[Quest]:
	var quests = get_unlocked_quests()
	return quests.sorted_custom(func(a, b):
		if a.pinned and !b.pinned:
			return true
		if !a.pinned and b.pinned:
			return false
		return a.quest_name < b.quest_name  # Alphabetical fallback
	)
