extends Control
var player: Node = null

var player_health_bar = null
var player_texture = null
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

func set_player_texture(texture, enemy_name, enemy_node):
	player_texture = texture
	start_cutscene(enemy_name, enemy_node)

func set_health_bar(health_node):
	player_health_bar = health_node

	
func _ready():
	visible = false
	$CanvasLayer.visible = false
	
	# Load and add input blocker
	


func start_cutscene(enemy_name: String, enemy_node):
	if enemy_name not in Global.enemy_database:
		print("Error: Enemy not found!")
		return

	var enemy_data = Global.enemy_database[enemy_name]

	# Reset health bar using correct enemy data
	enemy_bar.initialize(enemy_data)
	#enemy_bar.reset_health()

	Global.in_battle = true
	visible = true
	$CanvasLayer.visible = true
	# HIDE gameplay UI and map
	var scene = get_tree().get_current_scene()

	var map = scene.get_node("Map")
	var hud = scene.get_node("Control - HUD")
	var inventory = scene.get_node("Control - Inventory")
	var quest = scene.get_node("QuestMenu")
	var player = map.get_node("TemporaryPlayer")

	map.visible = false
	inventory.visible = false
	quest.visible = false

	# DISABLE player movement
	player.set_process(false)
	player.set_physics_process(false)

	# SET BACKGROUND IMAGE
	var bg_texture = load("res://User_Battle/Backgrounds/Pokemonbackgroun 1.jpeg")
	$CanvasLayer/BattleBackground.texture = bg_texture
	$CanvasLayer/BattleBackground.show()

	# Apply textures
	$CanvasLayer/PlayerSprite.texture = player_texture

	var enemy_texture = load(enemy_data["texture_path"])
	$CanvasLayer/EnemySprite.texture = enemy_texture
	
	$CanvasLayer/EnemySprite.scale = Vector2(.5, .5)
	$CanvasLayer/PlayerSprite.scale = Vector2(.5, .5)
	$CanvasLayer/PlayerSprite.position = Vector2(450, 500)
	$CanvasLayer/EnemySprite.position = Vector2(850, 350)

	$CanvasLayer/Enemy_EXP_Bar/LevelLabel.text = "LVL %d" % enemy_data["level"]

	$CanvasLayer/PlayerSprite.show()
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
	
	#await get_tree().create_timer(2).timeout
	#unlock_turn()

func unlock_turn():
	if suppress_trivia_popup:
		suppress_trivia_popup = false  # reset it for next time
		turn_locked = false
		input_blocker.visible = false
		return
	
	# Don't unlock the turn yet
	turn_locked = true
	
	#Allow user to use mouse so they can answer question
	input_blocker.visible = false

	# Create and show trivia popup
	var trivia_scene = preload("res://User_Battle/UI/trivia_popup.tscn")
	var trivia_popup = trivia_scene.instantiate()
	$CanvasLayer.add_child(trivia_popup)

	var trivia = get_unused_trivia_question(Global.trivia_questions)
	var question = trivia["question"]
	var answers = trivia["choices"]
	var correct = trivia["correct"]

	var raw_question = get_unused_trivia_question(Global.trivia_questions)
	
	#Randomize correct answer location
	var prepared = prepare_trivia_question(raw_question)

	trivia_popup.setup_question(prepared["question"], prepared["choices"], prepared["correct"])


	# Wait for answer
	trivia_popup.connect("answer_chosen", Callable(self, "_on_trivia_answer"))

func get_unused_trivia_question(all_questions: Array) -> Dictionary:
	var unused = []
	for q in all_questions:
		if q not in used_trivia_questions:
			unused.append(q)

	if unused.size() == 0:
		print("All trivia questions used - resetting...")
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

	var correct = original["correct"]
	var result = {
		"question": original["question"],
		"choices": shuffled,
		"correct": correct
	}
	return result


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
	if turn_locked:
		return
	lock_turn()
	player = get_node_or_null("/root/TestMain/Map/TemporaryPlayer")
	var final_damage = damage + player.get_total_strength()
	show_battle_message("Successfully attacked for %d damage" % final_damage)

	$AttackSuccessSFX.play()
	enemy_bar.take_damage(final_damage)  # ✅ Directly call it here

	if enemy_bar.current_health <= 0:
		await get_tree().create_timer(2).timeout
		print("Current Enemy: ", current_enemy)
		await show_battle_message("You won!")
		
		PlayerData.mark_enemy_defeated(current_enemy["name"])
		
		enemy_node_reference.queue_free()
		enemy_node_reference = null
		restore_gameplay()
	elif (!enemy_stunned):
		await get_tree().create_timer(2).timeout
		cpu_attack()


func player_heal(heal_amt):
	if turn_locked:
		return
	lock_turn()
	var result_text = "Successfully healed for %d HP" % heal_amt
	show_battle_message(result_text)
	await get_tree().create_timer(2).timeout
	cpu_attack()

func cpu_attack():
	var miss = rng.randf() <= 0.05
	if miss:
		$AttackMissSFX.play()
		await show_battle_message("CPU missed their attack!")
		print("Check 2")
		unlock_turn() 
		return

	var crit = rng.randf() <= 0.10
	var base_damage = current_enemy["damage"]
	var final_damage = base_damage
	if crit:
		final_damage = int(base_damage * 1.5)

	if player_health_bar:
		player_health_bar.lose_health(final_damage)  # ✅ Directly call the method
	
	if PlayerData.health <= 0:
		await show_battle_message("You lost!")
		get_tree().quit()
		

	await show_battle_message("CPU attacked for %d damage" % final_damage)
	print("Check 1")
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
