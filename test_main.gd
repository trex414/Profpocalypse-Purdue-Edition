extends Node2D

var map = null
var inventory = null
var hud = null
var QuestMenuScene = null
var majorInformation = null

func _ready():
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
	
	# Load Quest Screen
	QuestMenuScene = load("res://Quest/scenes/QuestMenu.tscn").instantiate()
	add_child(QuestMenuScene)
	
	majorInformation = load("res://MajorInformation/Scenes/MajorInformation.tscn").instantiate()
	add_child(majorInformation)
	
	QuestMenuScene.inventory = inventory
	

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
	if Input.is_action_just_pressed("inventory"):
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
			
			
