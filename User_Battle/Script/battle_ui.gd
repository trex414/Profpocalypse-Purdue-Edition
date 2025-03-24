extends Control


var player_texture = null

func set_player_texture(texture):
	player_texture = texture
	print("✅ player_texture received in battle_ui:", player_texture)
	start_cutscene()




func start_cutscene():
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

	# SET BACKGROUND IMAGE (already in scene as BattleBackground)
	# Load the background texture
	var bg_texture = load("res://User_Battle/Backgrounds/Pokemonbackgroun 1.jpeg")

	# Apply it to the TextureRect node
	$CanvasLayer/BattleBackground.texture = bg_texture
	$CanvasLayer/BattleBackground.show()
	
	print("Player texture:", player_texture)

	
	# Apply textures
	$CanvasLayer/PlayerSprite.texture = player_texture

# Grab enemy texture if using a Sprite2D on the map
	var red_image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	red_image.fill(Color.RED)

	var red_texture = ImageTexture.create_from_image(red_image)
	$CanvasLayer/EnemySprite.texture = red_texture


	$CanvasLayer/EnemySprite.scale = Vector2(4, 4)  # makes it larger visually
# Show and position

	$CanvasLayer/PlayerSprite.scale = Vector2(.5, .5)	

	# POSITION player and enemy
	$CanvasLayer/PlayerSprite.position = Vector2(450, 500)
	$CanvasLayer/EnemySprite.position = Vector2(850, 350)


	# Set dummy values for health and level
	$CanvasLayer/Enemy_Health_Bar/Health.value = 100
	$CanvasLayer/Enemy_EXP_Bar/LevelLabel.text = "LVL 5"

	$CanvasLayer/PlayerSprite.show()
	$CanvasLayer/EnemySprite.show()
	$CanvasLayer/Enemy_Health_Bar/Health.show()
	$CanvasLayer/Enemy_EXP_Bar/LevelLabel.show()

	# Animate player sliding in
