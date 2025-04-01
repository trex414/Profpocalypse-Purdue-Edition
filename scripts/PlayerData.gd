# Script manages player data. Contains functions to update inventory, position, level, etc. Add whatever information that pertains to the player as we create it.
extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_on_start()
	print("Inventory after load: ", inventory)
	print("=================")
	print("Item Bar after load: ", item_bar)
	print("=================")
	print("Potion Bar after load: ", potion_bar)
	print("=================")
	print("current quests: ", current_quests)
	print("=================")
	print("completed quests: ", completed_quests)
	print("=================")
	print("defeated enemies: ", defeated_enemies)


# Player data variables (initialized but not hardcoded)
var position: Vector2
var building_interior_position: Vector2  # Default starting position for building interior
#initialize player spots
var inventory = [null, null, null, null, null, null, null, null, null, null, null, null]
var potion_bar = [null, null, null, null, null]
var item_bar = [null, null]
var level: int
var exp: int
var health: int
var semester_index: int
var current_semester: String
var current_quests: Dictionary
static var completed_quests = []
var pinned_quests = []
var defeated_enemies = []

# Keybinding variables
var inventory_key: Key
var move_up: Key
var move_down: Key
var move_right: Key
var move_left: Key



# Function to get current game state (pass this to the save function when saving)
func get_game_state():
	return {
		"player": {
			"position": {"x": position.x, "y": position.y},
			"inventory": inventory,
			"item_bar": item_bar,
			"potion_bar": potion_bar,
			"level": level,
			"exp": exp,
			"health": health,
			"semester_index": semester_index,
			"current_semester": current_semester,
			"current_quests": current_quests,
			"completed_quests": completed_quests,
			"pinned_quests": pinned_quests,
			"defeated_enemies": defeated_enemies,
		},
		"keybindings": {
			"inventory_key": inventory_key,
			"move_up": move_up,
			"move_down": move_down,
			"move_right": move_right,
			"move_left": move_left,
		}
	}

	# Function to apply loaded data (for loading)
func apply_game_state(data):
	if "player" in data:
		var player_data = data["player"]
	
		if "position" in player_data:
			position = Vector2(player_data.position.x, player_data.position.y)
		
		if "inventory" in player_data:
			inventory = player_data.inventory.duplicate(true)  # Deep copy to prevent referencing issues
			
		if "item_bar" in player_data:
			item_bar = player_data.item_bar.duplicate(true) 
			
		if "potion_bar" in player_data:
			potion_bar = player_data.potion_bar.duplicate(true) 
		
		if "level" in player_data:
			level = player_data.level
		
		if "exp" in player_data:
			exp = player_data.exp
		
		if "health" in player_data:
			health = player_data.health
			
		if "semester_index" in player_data:
			semester_index = player_data.semester_index
			
		if "current_semester" in player_data:
			current_semester = player_data.current_semester
			
		if "current_quests" in player_data:
			current_quests = player_data.current_quests
			
		if "completed_quests" in player_data:
			completed_quests = player_data.completed_quests
			
		if "pinned_quests" in player_data:
			pinned_quests = player_data.pinned_quests
			
		if "defeated_enemies" in player_data:
			defeated_enemies = player_data.defeated_enemies
			
	if "keybindings" in data:
		var key_bindings = data["keybindings"]
		
		if "inventory_key" in key_bindings:
			inventory_key = key_bindings.inventory_key
			
		if "move_up" in key_bindings:
			move_up = key_bindings.move_up
			
		if "move_down" in key_bindings:
			move_down = key_bindings.move_down
			
		if "move_right" in key_bindings:
			move_right = key_bindings.move_right
			
		if "move_left" in key_bindings:
			move_left = key_bindings.move_left



	# Function to load data on startup
func load_on_start():
	SaveManager.load()

	# Function to set default values only if no save is found
func set_default_values():
	print("No save detected ==========>>>>")
	
	# Player Data Defaults
	position = Vector2(0, 0)
	inventory = []
	
	item_bar = []
	item_bar.clear()
	item_bar.resize(5)
	item_bar.fill({})
	
	potion_bar = []
	potion_bar.clear()
	potion_bar.resize(2)
	potion_bar.fill({})
	
	level = 1
	exp = 0
	health = 100
	semester_index = 0
	current_semester = "Freshman Fall"
	
	current_quests = {}
	completed_quests = []
	completed_quests.clear()
	pinned_quests = []
	defeated_enemies = []
	
	#Key Binding Defaults
	inventory_key = 69
	move_left = 65
	move_right = 68
	move_up = 87
	move_down = 83
	 
	
static func is_quest_completed(quest_id: String) -> bool:
	return quest_id in completed_quests
	
func mark_enemy_defeated(enemy_name: String):
	if enemy_name not in defeated_enemies:
		defeated_enemies.append(enemy_name)
		print("Defeated Enemies:", defeated_enemies)

func is_enemy_defeated(enemy_name: String) -> bool:
	return enemy_name in defeated_enemies
