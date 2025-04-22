extends Node2D

@export var enemy_name: String
@export var enemy_node_path: NodePath

var enemy_instance
@onready var locked_label = $Label

var norm := 0.0 

var canbe = false



func trigger_cutscene():
	var hud = get_tree().current_scene.get_node("Control - HUD")
	var battle_ui = hud.battle_ui

	enemy_instance = get_node(enemy_node_path)

	battle_ui.start_cutscene(enemy_name, enemy_instance)


func _on_body_entered(body):
	if body.name != "TemporaryPlayer":
		return

	if enemy_name == "HHS TA" or enemy_name == "Engineering TA" or enemy_name == "Science TA" or enemy_name == "Liberal Arts TA":
		trigger_cutscene()

	# Doomsmore – no prereq
	if enemy_name == "Prof Doomsmore":
		trigger_cutscene()
		

	# Sel-key → requires Doomsmore
	elif enemy_name == "Prof Sel-Key":
		print("inininin")
		if QuestManager.is_quest_completed("Main Story: Prof Doomsmore"):
			trigger_cutscene()
		else:
			norm = 3953
			if locked_label == null:
				print("label not fount")
			print("in the right spot")
			show_locked_message("Must defeat Prof Doomsmore first!")
			

	# Turkey → requires Doomsmore
	elif enemy_name == "Prof Turkey":
		if QuestManager.is_quest_completed("Main Story: Prof Doomsmore"):
			trigger_cutscene()
		else:
			norm = 4083
			show_locked_message("Must defeat Prof. Doomsmore first!")

	# Gust-Codes → requires Turkey
	elif enemy_name == "Prof Gust-Codes":
		if QuestManager.is_quest_completed("Main Story: Prof Turkey"):
			trigger_cutscene()
		else:
			norm = 0
			print("in gustcodes")
			show_locked_message("Must defeat Prof. Turkey first!")

	# PosadaBytes → requires Sel-key AND Turkey
	elif enemy_name == "Prof PosadaBytes":
		if QuestManager.is_quest_completed("Main Story: Prof Sel-key") and QuestManager.is_quest_completed("Main Story: Prof Turkey"):
			trigger_cutscene()
		elif QuestManager.is_quest_completed("Main Story: Prof Turkey"):
			norm = 0
			show_locked_message("Must defeat Prof. Sel-Key first!")
		elif QuestManager.is_quest_completed("Main Story: Prof Sel-Key"):
			norm = 0
			show_locked_message("Must defeat Prof. Turkey first!")
		else:
			norm = 0
			show_locked_message("Must defeat Prof. Turkey and Prof. Sel-Key first!")			

	# Gust-Stack → requires PosadaBytes AND Gust-Codes
	elif enemy_name == "Prof Gust-Stack":
		if QuestManager.is_quest_completed("Main Story: Prof PosadaBytes") and QuestManager.is_quest_completed("Main Story: Prof Gust-Codes"):
			trigger_cutscene()
		elif QuestManager.is_quest_completed("Main Story: Prof PosadaBytes"):
			norm = 0
			show_locked_message("Must defeat Prof. Gust-Codes first!")
		elif QuestManager.is_quest_completed("Main Story: Prof Gust-Codes"):
			norm = 0
			show_locked_message("Must defeat Prof. PosadaBytes first!")
		else:
			norm = 0
			show_locked_message("Must defeat Prof. PosadaBytes and Prof. Gust-Codes first!")		

	# KernelComer → requires Gust-Stack
	elif enemy_name == "Prof KernelComer":
		if QuestManager.is_quest_completed("Main Story: Prof Gust-Stack"):
			trigger_cutscene()
		else:
			norm = 0
			show_locked_message("Must defeat Prof Gust-Stack first!")

	# CodeZhang → requires PosadaBytes
	elif enemy_name == "Prof CodeZhang":
		if QuestManager.is_quest_completed("Main Story: Prof PosadaBytes"):
			trigger_cutscene()
		else:
			norm = 0
			show_locked_message("Must defeat Prof PosadaBytes first!")

	# AlgoKnight → requires PosadaBytes
	elif enemy_name == "Prof AlgoKnight":
		if QuestManager.is_quest_completed("Main Story: Prof PosadaBytes"):
			trigger_cutscene()
		else:
			norm = 0
			show_locked_message("Must defeat Prof PosadaBytes first!")

	# CapstoneCrafter → requires PosadaBytes
	elif enemy_name == "Prof CapstoneCrafter":
		if QuestManager.is_quest_completed("Main Story: Prof PosadaBytes"):
			trigger_cutscene()
		else:
			norm = 0
			show_locked_message("Must defeat Prof. PosadaBytes first!")

	# BugSquasher → requires CodeZhang
	elif enemy_name == "Prof BugSquasher":
		if QuestManager.is_quest_completed("Main Story: Prof CodeZhang"):
			trigger_cutscene()
		else:
			norm = 0
			show_locked_message("Must defeat Prof. CodeZhang first!")

	else:
		print("⚠️ Unknown enemy or no logic assigned for:", enemy_name)


func show_locked_message(text: String):
	if locked_label:
		locked_label.set("theme_override_font_sizes/font_size", 16)
		locked_label.set("theme_override_font_sizes/outline_size", 30)
		locked_label.add_theme_color_override("font_outline_color", Color.BLACK)
		locked_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		locked_label.custom_minimum_size = Vector2(100, 200)
		locked_label.position.y = norm - 40
		locked_label.text = text
		locked_label.visible = true
	
		await get_tree().create_timer(2.5).timeout
		locked_label.visible = false
		
