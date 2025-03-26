extends Control

var player_texture = null
var turn_locked = false
var rng = RandomNumberGenerator.new()

func set_player_texture(texture):
	player_texture = texture
	start_cutscene()
	
func _ready():
	visible = false
	$CanvasLayer.visible = false



func start_cutscene():
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

	var red_image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	red_image.fill(Color.RED)
	var red_texture = ImageTexture.create_from_image(red_image)
	$CanvasLayer/EnemySprite.texture = red_texture

	$CanvasLayer/EnemySprite.scale = Vector2(4, 4)
	$CanvasLayer/PlayerSprite.scale = Vector2(.5, .5)
	$CanvasLayer/PlayerSprite.position = Vector2(450, 500)
	$CanvasLayer/EnemySprite.position = Vector2(850, 350)

	$CanvasLayer/Enemy_Health_Bar/Health.value = 100
	$CanvasLayer/Enemy_EXP_Bar/LevelLabel.text = "LVL 5"

	$CanvasLayer/PlayerSprite.show()
	$CanvasLayer/EnemySprite.show()
	$CanvasLayer/Enemy_Health_Bar/Health.show()
	$CanvasLayer/Enemy_EXP_Bar/LevelLabel.show()

	$CanvasLayer/Button.connect("pressed", Callable(self, "try_leave_fight"))

func lock_turn():
	turn_locked = true
	var scene = get_tree().current_scene
	var hud = scene.get_node_or_null("Control - HUD")
	var inventory = scene.get_node_or_null("Control - Inventory")

	if hud:
		for child in hud.get_children():
			if child is Button:
				child.disabled = true

	if inventory:
		for child in inventory.get_children():
			if child is Button:
				child.disabled = true

	await get_tree().create_timer(2).timeout
	unlock_turn()



func unlock_turn():
	turn_locked = false
	var scene = get_tree().current_scene
	var hud = scene.get_node_or_null("Control - HUD")
	var inventory = scene.get_node_or_null("Control - Inventory")

	if hud:
		for child in hud.get_children():
			if child is Button:
				child.disabled = false

	if inventory:
		for child in inventory.get_children():
			if child is Button:
				child.disabled = false



func show_battle_message(msg: String) -> void:
	$CanvasLayer/BattleMessage.text = msg
	$CanvasLayer/BattleMessage.show()
	await get_tree().create_timer(2).timeout
	$CanvasLayer/BattleMessage.hide()


func try_leave_fight():
	if turn_locked:
		return

	if rng.randf() <= 0.6:
		show_battle_message("Successfully escaped!")
		
		await get_tree().create_timer(2).timeout
		restore_gameplay()
	else:
		show_battle_message("Escape failed! CPU is attacking...")
		lock_turn()
		await get_tree().create_timer(2).timeout
		cpu_attack()


func player_attack(damage):
	if turn_locked:
		return
	lock_turn()
	var result_text = "Successfully attacked for %d damage" % damage
	show_battle_message(result_text)
	# future logic: reduce enemy health
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
		show_battle_message("CPU missed their attack!")
		return

	var crit = rng.randf() <= 0.10
	var base_damage = 1
	var final_damage = base_damage
	if crit:
		final_damage = int(base_damage * 1.5)

	var health_bar = get_node_or_null("CanvasLayer/Health_Bar")
	if health_bar:
		health_bar.lose_health(final_damage)

	show_battle_message("CPU attacked for %d damage" % final_damage)
	
func restore_gameplay():
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
	
	player.set_process(true)
	player.set_physics_process(true)
	
	visible = false
	$CanvasLayer.visible = false
