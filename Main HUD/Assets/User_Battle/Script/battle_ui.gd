extends Control

var player: Node = null

var player_health_bar = null
var turn_locked = false
var enemy_stunned = false
var rng = RandomNumberGenerator.new()
@onready var enemy_bar = $CanvasLayer/Enemy_Health_Bar

@export var new_music: AudioStream

var input_blocker = null
var suppress_trivia_popup = false

var used_trivia_questions = []

var enemy_scene = preload("res://User_Battle/Scene/enemy.tscn")
var current_enemy = null
var enemy_node_reference = null

func set_input_blocker(blocker):
	input_blocker = blocker

func set_health_bar(health_node):
	player_health_bar = health_node

func _ready():
	visible = false
	$CanvasLayer.visible = false
	
	var last_character_file = FileAccess.open("res://CharacterCustomization/last_saved_character.json", FileAccess.READ)
	var last_character_data = JSON.parse_string(last_character_file.get_as_text())
	last_character_file.close()
	load_character(last_character_data["name"])
	
func load_character(character_name):
	var file = FileAccess.open("res://CharacterCustomization/CustomCharacters/" + character_name + ".json", FileAccess.READ)
	var save_data = JSON.parse_string(file.get_as_text())
	file.close()

	$CanvasLayer/body_root/face.texture = load(save_data["face_texture"])
	$CanvasLayer/body_root/face/features.texture = load(save_data["features_texture"])
	$CanvasLayer/body_root/face/features/hair.texture = load(save_data["hair_texture"])
	$CanvasLayer/body_root/shirt.texture = load(save_data["shirt_texture"])
	$CanvasLayer/body_root/pant.texture = load(save_data["pant_texture"])
	$CanvasLayer/body_root/pant/pant2.texture = load(save_data["pant2_texture"])
	$CanvasLayer/body_root/pant/pant2/shoe.texture = load(save_data["shoe1_texture"])
	$CanvasLayer/body_root/pant/pant2/shoe2.texture = load(save_data["shoe2_texture"])
	$CanvasLayer/body_root/sleeve.texture = load(save_data["arm_texture"])
	$CanvasLayer/body_root/sleeve/sleeve2.texture = load(save_data["arm2_texture"])
	$CanvasLayer/body_root/sleeve/sleeve2/hand.texture = load(save_data["hand_texture"])
	$CanvasLayer/body_root/sleeve/sleeve2/hand2.texture = load(save_data["hand2_texture"])
	$CanvasLayer/body_root/shirt/neck.texture = load(save_data["neck_texture"])
	$CanvasLayer/body_root/pant/pant2/belt.texture = load(save_data["belt_texture"])
	$CanvasLayer/body_root/shirt/class.texture = load(save_data["class_texture"])

func start_cutscene(enemy_name: String, enemy_node):
	if enemy_name not in Global.enemy_database:
		print("Error: Enemy not found!")
		return

	var enemy_data = Global.enemy_database[enemy_name]

	enemy_bar.initialize(enemy_data)
	Global.in_battle = true
	visible = true
	$CanvasLayer.visible = true

	var scene = get_tree().get_current_scene()
	var map = scene.get_node("Map")
	var hud = scene.get_node("Control - HUD")
	var inventory = scene.get_node("Control - Inventory")
	var quest = scene.get_node("QuestMenu")
	var player = map.get_node("TemporaryPlayer")

	map.visible = false
	inventory.visible = false
	quest.visible = false

	player.set_process(false)
	player.set_physics_process(false)

	var bg_texture = load("res://User_Battle/Backgrounds/Purdue Room 2.png")
	$CanvasLayer/BattleBackground.texture = bg_texture
	$CanvasLayer/BattleBackground.show()

	var enemy_texture = load(enemy_data["texture_path"])
	$CanvasLayer/EnemySprite.texture = enemy_texture
	
	$CanvasLayer/EnemySprite.scale = Vector2(.20, .20)
	$CanvasLayer/PlayerSprite.hide()  # Hide player sprite
	$CanvasLayer/EnemySprite.position = Vector2(925, 375)

	$CanvasLayer/Enemy_EXP_Bar/NameLabel.text = enemy_data["name"]
	$CanvasLayer/Enemy_EXP_Bar/LevelLabel.text = "Weakness: " + enemy_data["weakness"] + " | LVL %d" % enemy_data["level"]
	$CanvasLayer/EnemySprite.show()
	$CanvasLayer/Enemy_Health_Bar/Health.show()
	$CanvasLayer/Enemy_EXP_Bar/LevelLabel.show()

	$CanvasLayer/Button.connect("pressed", Callable(self, "try_leave_fight"))

	MusicManager.play_battle_music(new_music)
	
	current_enemy = enemy_data
	enemy_node_reference = enemy_node
	print("Check 3")
	unlock_turn()

func lock_turn():
	turn_locked = true
	input_blocker.visible = true
	
	if Global.enemy_status_effect_active:
		cpu_apply_status_effect_if_active()

func unlock_turn():
	if suppress_trivia_popup:
		suppress_trivia_popup = false
		turn_locked = false
		input_blocker.visible = false
		return
	if Global.status_effect_active:
		var hud = get_tree().get_current_scene().get_node("Control - HUD")
		if hud.has_method("apply_status_effect_if_active"):
			hud.apply_status_effect_if_active()
	print(enemy_stunned)
	if enemy_stunned:
		print("⛔ Enemy stunned — skipping trivia.")
		enemy_stunned = false  # Reset stun for next turn
		turn_locked = false
		input_blocker.visible = false
	else:
		
		turn_locked = true
		input_blocker.visible = false

		var trivia_scene = preload("res://User_Battle/UI/trivia_popup.tscn")
		var trivia_popup = trivia_scene.instantiate()
		$CanvasLayer.add_child(trivia_popup)

		var trivia = get_unused_trivia_question(Global.trivia_questions)
		var question = trivia["question"]
		var answers = trivia["choices"]
		var correct = trivia["correct"]

		var raw_question = get_unused_trivia_question(Global.trivia_questions)
		var prepared = prepare_trivia_question(raw_question)

		trivia_popup.setup_question(prepared["question"], prepared["choices"], prepared["correct"])
		trivia_popup.connect("answer_chosen", Callable(self, "_on_trivia_answer"))

func get_unused_trivia_question(all_questions: Array) -> Dictionary:
	var unused = []
	for q in all_questions:
		if q not in used_trivia_questions:
			unused.append(q)
	if unused.size() == 0:
		used_trivia_questions.clear()
		unused = all_questions.duplicate()
	var trng = RandomNumberGenerator.new()
	trng.randomize()
	var chosen = unused[trng.randi_range(0, unused.size() - 1)]
	used_trivia_questions.append(chosen)
	return chosen

func prepare_trivia_question(original: Dictionary) -> Dictionary:
	var shuffled = original["choices"].duplicate()
	shuffled.shuffle()
	return {
		"question": original["question"],
		"choices": shuffled,
		"correct": original["correct"]
	}

func _on_trivia_answer(correct: bool):
	if correct:
		turn_locked = false
		input_blocker.visible = false
		show_battle_message("Correct! You may take your turn.")
	else:
		show_battle_message("Incorrect... CPU will attack!")
		await get_tree().create_timer(2).timeout
		cpu_attack()

func show_battle_message(msg: String) -> void:
	$CanvasLayer/BattleMessage.text = msg
	$CanvasLayer/BattleMessage.show()
	await get_tree().create_timer(2).timeout
	$CanvasLayer/BattleMessage.hide()

func try_leave_fight():
	if turn_locked:
		return
	if rng.randf() <= 0.7:
		show_battle_message("Successfully escaped!")
		await get_tree().create_timer(2).timeout
		restore_gameplay()
	else:
		lock_turn()
		$EscapeFailedSFX.play()
		show_battle_message("Escape failed! CPU is attacking...")
		await get_tree().create_timer(2).timeout
		cpu_attack()

func player_attack(damage):
	if (enemy_stunned):
		turn_locked = false
		input_blocker.visible = false
	if turn_locked:
		return
	lock_turn()
	player = get_node_or_null("/root/TestMain/Map/TemporaryPlayer")
	var final_damage = damage + player.get_total_strength()
	show_battle_message("Successfully attacked for %d damage" % final_damage)
	$AttackSuccessSFX.play()
	enemy_bar.take_damage(final_damage)
	#enemy killed
	if enemy_bar.current_health <= 0:
		await get_tree().create_timer(2).timeout
		await show_battle_message("You won!")
		PlayerData.mark_enemy_defeated(current_enemy["name"])
		
		var quest_name = "Main Story: " + current_enemy["name"]
		QuestManager.mark_ready_to_complete(quest_name)

		enemy_node_reference.queue_free()
		enemy_node_reference = null
		
		restore_gameplay()
	elif (!enemy_stunned):
		await get_tree().create_timer(2).timeout
		cpu_attack()
	if (enemy_stunned):
		enemy_stunned = false
		turn_locked = false
		input_blocker.visible = false
		show_battle_message("You can attack again")

func player_heal(heal_amt):
	if turn_locked:
		return
	lock_turn()
	show_battle_message("Successfully healed for %d HP" % heal_amt)
	await get_tree().create_timer(2).timeout
	cpu_attack()

func cpu_apply_status_effect_if_active():
	if Global.enemy_status_effect_active:
		var damage = randi_range(Global.enemy_status_effect_damage_range.x, Global.enemy_status_effect_damage_range.y)
		var msg = "💢 %s effect dealt %d damage!" % [Global.enemy_status_effect_type.capitalize(), damage]
		await show_battle_message(msg)

		await get_tree().create_timer(1).timeout

		player_health_bar.lose_health(damage)
		Global.enemy_status_effect_turns_left -= 1

		if Global.enemy_status_effect_turns_left <= 0:
			Global.enemy_status_effect_active = false
			Global.enemy_status_effect_type = ""
			print("✅ Status effect ended.")

func cpu_attack():
	var miss = rng.randf() <= current_enemy["miss"]
	if miss:
		$AttackMissSFX.play()
		await show_battle_message("CPU missed their attack!")
		unlock_turn() 
		return
	var crit = rng.randf() <= current_enemy["crit"]
	var base_damage = current_enemy["damage"]
	var final_damage = int(base_damage * 1.5) if crit else base_damage

	if rng.randf() < current_enemy["effect_chance"]:
		# Don't reapply if the same effect is already active
		if Global.enemy_status_effect_active and Global.enemy_status_effect_type == current_enemy["effect_type"]:
			print("❌ Status effect", current_enemy["effect_type"], "already active. Skipping.")
		else:
			var effect = current_enemy["effect_type"]
			var duration = randi_range(current_enemy["effect_turns_range"].x, current_enemy["effect_turns_range"].y)
			var damage_range = current_enemy["effect_damage_range"]

			Global.enemy_status_effect_active = true
			Global.enemy_status_effect_type = effect
			Global.enemy_status_effect_turns_left = duration
			Global.enemy_status_effect_damage_range = damage_range

			print("🩸 Applied", effect, "for", duration, "turns!")

			await show_battle_message("🩸 Applied %s for %d turns!" % [effect.capitalize(), duration])

			await get_tree().create_timer(1).timeout

	if player_health_bar:
		player_health_bar.lose_health(final_damage)

	if PlayerData.health <= 0:
		await show_battle_message("You lost!")
		get_tree().quit()

	await show_battle_message("CPU attacked for %d damage" % final_damage)
	unlock_turn() 

func restore_gameplay():
	$EscapeSuccessSFX.play()
	Global.in_battle = false
	var scene = get_tree().get_current_scene()
	var map = scene.get_node("Map")
	var hud = scene.get_node("Control - HUD")
	var inventory = scene.get_node("Control - Inventory")
	var quest = scene.get_node("QuestMenu")
	var player = map.get_node("TemporaryPlayer")

	map.visible = true
	hud.visible = true
	inventory.visible = true
	quest.visible = true

	input_blocker.visible = false
	used_trivia_questions.clear()

	player.set_process(true)
	player.set_physics_process(true)

	visible = false
	$CanvasLayer.visible = false

	MusicManager.restore_previous_music()
	
