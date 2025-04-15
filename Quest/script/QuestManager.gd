extends Node
const Quest = preload("res://Quest/script/Quest.gd")
var all_quests = {}  # quest_name -> Quest object
var completed_quests = []

var available_quests: Array[Quest] = []
var pinned_quests: Array[Quest] = []
var quest_menu = null
var ready_to_complete = {}  # quest_name -> true


# All quests
var open_inventory_quest = load("res://Quest/assets/OpenInventory.tres")
#var walk_forward_quest = load("res://Quest/assets/Walk-Forward.tres")
#var walk_backward_quest = load("res://Quest/assets/Walk-Backwards.tres")
#var walk_right_quest = load("res://Quest/assets/Walk-Right.tres")
#var walk_left_quest = load("res://Quest/assets/Walk-Left.tres")
var rising_lag_quest = load("res://Quest/assets/The-rising-lag.tres")
var doomsmore_quest = load("res://Quest/assets/Doomsmore.tres")
var turkey_quest = load("res://Quest/assets/Turkey.tres")
var selkey_quest = load("res://Quest/assets/Sel-key.tres")
var gustcodes_quest = load("res://Quest/assets/Gust-codes.tres")
var posadabytes_quest = load("res://Quest/assets/Posadabytes.tres")
var guststack_quest = load("res://Quest/assets/Gust-stack.tres")
var kernelcomer_quest = load("res://Quest/assets/Kernelcomer.tres")
var codezhang_quest = load("res://Quest/assets/Codezhang.tres")
var algoknight_quest = load("res://Quest/assets/AlgoKnight.tres")
var capstonecrafter_quest = load("res://Quest/assets/Capstonecrafter.tres")
var bugsquasher_quest = load("res://Quest/assets/Bugsquasher.tres")
var library = load("res://Quest/assets/library.tres")
var walk = load("res://Quest/assets/walk.tres")
var landmark = load("res://Quest/assets/landmarks.tres")
var prof_res = load("res://Quest/assets/prof_res.tres")


signal pinned_quests_updated(pinned_quests: Array[Quest])
signal quest_completed(quest_name: String)

func _ready():
	all_quests = PlayerData.current_quests
	completed_quests = PlayerData.completed_quests
	print("Beginning Completed Quests: ", PlayerData.completed_quests)
	
	# Load and register all quests here
	add_quest(open_inventory_quest)
	#add_quest(walk_forward_quest)
	#add_quest(walk_backward_quest)
	#add_quest(walk_left_quest)
	#add_quest(walk_right_quest)
	add_quest(rising_lag_quest)
	add_quest(doomsmore_quest)
	add_quest(turkey_quest)
	add_quest(selkey_quest)
	add_quest(gustcodes_quest)
	add_quest(posadabytes_quest)
	add_quest(guststack_quest)
	add_quest(kernelcomer_quest)
	add_quest(codezhang_quest)
	add_quest(algoknight_quest)
	add_quest(capstonecrafter_quest)
	add_quest(bugsquasher_quest)
	add_quest(library)
	add_quest(walk)
	add_quest(landmark)
	add_quest(prof_res)
	
	

	
	for quest in all_quests.values():
		if quest.quest_name in PlayerData.completed_quests:
			quest.is_completed = true
			
	for quest in all_quests.values():
		if quest.quest_name in PlayerData.pinned_quests and quest.quest_name not in PlayerData.completed_quests:
			quest.pinned = true
			pinned_quests.append(quest)

func set_quest_menu(menu):
	quest_menu = menu

func add_quest(quest: Quest):
	all_quests[quest.quest_name] = quest

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

		# Unlock any quests that depend on this one
		for quest in all_quests.values():
			if quest.is_completed:
				continue
			if quest in get_unlocked_quests():
				continue  # Already unlocked
			if can_start_quest(quest):
				print("✅ Unlocked quest:", quest.quest_name)
			PlayerData.current_quests[quest.quest_name] = quest
		if ready_to_complete.has(name):
			ready_to_complete.erase(name)
		# Trigger the complete button functionality
		display_complete_button(quest1)

func display_complete_button(quest: Quest):
	if quest_menu:
		quest_menu.display_complete_button(quest)


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

func mark_ready_to_complete(name: String):
	if !all_quests.has(name) or all_quests[name].is_completed:
		return
	match name:
		"Campus Curiosity Part 2: The Library Tour":
			if is_library_quest_ready():
				ready_to_complete[name] = true
				if name not in PlayerData.ready_to_complete:
					PlayerData.ready_to_complete.append(name)
			else:
				return
		"Movement Mastery: Walk All Ways":
			if is_movement_mastery_ready():
				ready_to_complete[name] = true
				if name not in PlayerData.ready_to_complete:
					PlayerData.ready_to_complete.append(name)
			else:
				return
		"Campus Curiosity Part 1: Landmarks of Lore":
			if is_campus_curiosity_ready():
				ready_to_complete[name] = true
				if name not in PlayerData.ready_to_complete:
					PlayerData.ready_to_complete.append(name)
			else:
				return
		"Campus Curiosity Part 3: Professor’s Research":
			if is_professors_research_ready():
				ready_to_complete[name] = true
				if name not in PlayerData.ready_to_complete:
					PlayerData.ready_to_complete.append(name)
			else:
				return
		_:  # Default
			ready_to_complete[name] = true
			if name not in PlayerData.ready_to_complete:
				PlayerData.ready_to_complete.append(name)

	# Now only update the UI if it's truly ready
	print(ready_to_complete[name])
	if ready_to_complete.get(name, false) and quest_menu:
		quest_menu.show_quest_details(all_quests[name], false)
		quest_menu.display_complete_button(all_quests[name])

	
func is_library_quest_ready() -> bool:
	return Global.visited_walc and Global.visited_hicks and Global.visited_armstrong and Global.visited_lilly and Global.visited_vet
func is_movement_mastery_ready() -> bool:
	return Global.move_forward >= 30 and Global.move_backward >= 30 and Global.move_left >= 30 and Global.move_right >= 30
func is_campus_curiosity_ready() -> bool:
	return Global.visited_fountain and Global.visited_union and Global.visited_belltower and Global.visited_mall and Global.visited_corec
func is_professors_research_ready() -> bool:
	return Global.visited_cs and Global.visited_physics and Global.visited_chemistry and Global.visited_hicks_notes
