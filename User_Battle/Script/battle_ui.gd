extends Control

var player_health_bar = null
var player_texture = null
var turn_locked = false
var rng = RandomNumberGenerator.new()
@onready var enemy_bar = $CanvasLayer/Enemy_Health_Bar

@export var new_music: AudioStream

var input_blocker = null

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

	#var red_image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	#red_image.fill(Color.RED)
	#var red_texture = ImageTexture.create_from_image(red_image)
	#$CanvasLayer/EnemySprite.texture = red_texture

	#$CanvasLayer/EnemySprite.texture = load(Global.enemy_database["texture_path"])
	var enemy_texture = load(enemy_data["texture_path"])
	$CanvasLayer/EnemySprite.texture = enemy_texture
	
	$CanvasLayer/EnemySprite.scale = Vector2(.5, .5)
	$CanvasLayer/PlayerSprite.scale = Vector2(.5, .5)
	$CanvasLayer/PlayerSprite.position = Vector2(450, 500)
	$CanvasLayer/EnemySprite.position = Vector2(850, 350)

	#enemy_bar.reset_health(enemy_data["max_health"])
	#$CanvasLayer/Enemy_Health_Bar/Health.value = Global.enemy_database["max_health"]
	$CanvasLayer/Enemy_EXP_Bar/LevelLabel.text = "LVL %d" % enemy_data["level"]


	#$CanvasLayer/Enemy_Health_Bar/Health.value = 100
	#$CanvasLayer/Enemy_EXP_Bar/LevelLabel.text = "LVL 5"

	$CanvasLayer/PlayerSprite.show()
	$CanvasLayer/EnemySprite.show()
	$CanvasLayer/Enemy_Health_Bar/Health.show()
	$CanvasLayer/Enemy_EXP_Bar/LevelLabel.show()

	$CanvasLayer/Button.connect("pressed", Callable(self, "try_leave_fight"))

	MusicManager.play_battle_music(new_music)
	
	current_enemy = enemy_data
	enemy_node_reference = enemy_node
	unlock_turn()


func lock_turn():
	turn_locked = true
	input_blocker.visible = true
	#await get_tree().create_timer(2).timeout
	#unlock_turn()

func unlock_turn():
	turn_locked = false
	input_blocker.visible = false



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

	show_battle_message("Successfully attacked for %d damage" % damage)

	$AttackSuccessSFX.play()
	enemy_bar.take_damage(damage)  # ✅ Directly call it here

	if enemy_bar.current_health <= 0:
		await get_tree().create_timer(2).timeout
		print("Current Enemy: ", current_enemy)
		await show_battle_message("You won!")
		
		PlayerData.mark_enemy_defeated(current_enemy["name"])
		
		enemy_node_reference.queue_free()
		enemy_node_reference = null
		restore_gameplay()
	else:
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
	
	player.set_process(true)
	player.set_physics_process(true)
	
	visible = false
	$CanvasLayer.visible = false
	
	MusicManager.restore_previous_music()
