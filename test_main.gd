extends Node2D

var map = null
var inventory = null
var hud = null
var abilitiesPreview = null
var QuestMenuScene = null
var majorInformation = null


func _ready():

	Global.tutorial_screen = $"Tutorial UI"
	
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print("Game started. Press E to open inventory.")
	
	map = load("res://Main Map/scenes/Profpocalypse Main Map.tscn").instantiate()
	add_child(map)

	# Load Inventory
	inventory = load("res://Inventory/scenes/inventory.tscn").instantiate()
	add_child(inventory)

	# Load HUD
	hud = load("res://Main HUD/Scenes/hud.tscn").instantiate()
	add_child(hud)
	
	# Load abilities preview
	abilitiesPreview = load("res://Abilities/Scenes/AbilitiesPreview.tscn").instantiate()
	add_child(abilitiesPreview)
	
	# Load Quest Screen
	QuestMenuScene = load("res://Quest/scenes/QuestMenu.tscn").instantiate()
	add_child(QuestMenuScene)
	
	majorInformation = load("res://MajorInformation/Scenes/MajorInformation.tscn").instantiate()
	add_child(majorInformation)
	
	QuestMenuScene.inventory = inventory
	
		# Load Battle UI early and hide it
	var battle_ui = load("res://User_Battle/Scene/battle_ui.tscn").instantiate()
	battle_ui.visible = false
	battle_ui.hide()
	add_child(battle_ui)
	
	var input_blocker = load("res://User_Battle/Scene/inputblocker.tscn").instantiate()
	input_blocker.visible = false
	add_child(input_blocker)
	battle_ui.set_input_blocker(input_blocker)
	
	var health_bar = hud.get_node("CanvasLayer/Health_Bar")
	battle_ui.set_health_bar(health_bar)


# Pass to HUD
	hud.set_battle_ui(battle_ui)
	

	# Pass inventory reference to HUD
	hud.set_inventory(inventory)
	inventory.set_main_hud(hud)
	SaveManager.set_inventory(inventory)
	SaveManager.set_main_hud(hud)
	
	SaveManager.load()

	# Set the window size to 1280x720 (720p resolution)
	var window = get_viewport().get_window()
	if window:
		window.size = Vector2(1280, 720)
		
	PlayerData.ready
	


func _process(delta):
	if Input.is_action_just_pressed("inventory_key"):
		# Check if inventory exists, otherwise create it
		if inventory == null:
			inventory = load("res://Inventory/scenes/inventory.tscn").instantiate()
			add_child(inventory)  # Add inventory to the scene
			print("Inventory opened.")
		else:
			inventory.toggle_inventory()  # Toggle visibility
	if Input.is_action_just_pressed("QuestMenu"):
		if QuestMenuScene == null:
			QuestMenuScene = load("res://Quest/scenes/QuestMenu.tscn").instantiate()
			add_child(QuestMenuScene)
			print("QuestMenu opened.")
		else:
			QuestMenuScene.toggle_questmenu()
	if Input.is_action_just_pressed("courses_information"):
		if majorInformation == null:
			majorInformation = load("res://MajorInformation/Scenes/MajorInformation.tscn").instantiate()
			add_child(majorInformation)
			print("Courses Information opened.")
		else:
			majorInformation.toggle_MajorInfo()
			
			
# Main game script (extends Node2D)
func change_map(new_map_path: String):
	if map:  # If a map already exists, remove it
		map.call_deferred("queue_free")  # Defer the removal of the map
	call_deferred("_load_new_map", new_map_path)  # Defer loading the new map

func _load_new_map(new_map_path: String):
	map = load(new_map_path).instantiate()  # Load the new map
	add_child(map)  # Add the new map to the scene
	move_child(map, 0)  # Ensure the map is at the bottom (below UI)
