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
var max_health: int
var semester_index: int
var current_semester: String
var current_quests: Dictionary
static var completed_quests = []
var pinned_quests = []
var ready_to_complete: Array = []
var defeated_enemies = []
var abilities_levels = []
var study_tokens: int
var achievements_unlocked = []

# Keybinding variables
var inventory_key: Key
var move_up: Key
var move_down: Key
var move_right: Key
var move_left: Key

#player abilities
var permanent_strength: int
var permanent_speed: float
var brilliant_chance_bonus: float

#quests
var move_forward_count: int = 0
var move_backward_count: int = 0
var move_left_count: int = 0
var move_right_count: int = 0

var visited_walc := false
var visited_hicks := false
var visited_armstrong := false
var visited_lilly := false
var visited_vet := false

var visited_fountain := false
var visited_union := false
var visited_belltower := false
var visited_mall := false
var visited_corec := false

var visited_cs := false
var visited_physics := false
var visited_chemistry := false
var visited_hicks_notes := false

# Active potion tracking
var active_potion_type: String = ""
var active_speed_boost: float = 0.0
var temp_strength_bonus: int = 0
var enemies_defeated: int = 0



#NPC Rewards
var npc_rewards = {}

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
			"abilities_levels": abilities_levels,
			"study_tokens": study_tokens,
			"achievements_unlocked": achievements_unlocked,
			"permanent_strength": permanent_strength,
			"max_health": max_health,
			"ready_to_complete": ready_to_complete,
			"permanent_speed": permanent_speed,
			"brilliant_chance_bonus": brilliant_chance_bonus,
			"active_potion_type": active_potion_type,
			"active_speed_boost": active_speed_boost,
			"temp_strength_bonus": temp_strength_bonus,
			"enemies_defeated": enemies_defeated,

		},
		"keybindings": {
			"inventory_key": inventory_key,
			"move_up": move_up,
			"move_down": move_down,
			"move_right": move_right,
			"move_left": move_left,
		},
		"move_data": {
			"move_forward_count": move_forward_count,
			"move_backward_count": move_backward_count,
			"move_left_count": move_left_count,
			"move_right_count": move_right_count
		},
		"visited_locations": {
			"visited_walc": visited_walc,
			"visited_hicks": visited_hicks,
			"visited_armstrong": visited_armstrong,
			"visited_lilly": visited_lilly,
			"visited_vet": visited_vet,
			"visited_fountain": visited_fountain,
			"visited_union": visited_union,
			"visited_belltower": visited_belltower,
			"visited_mall": visited_mall,
			"visited_corec": visited_corec,
			"visited_cs": visited_cs,
			"visited_physics": visited_physics,
			"visited_chemistry": visited_chemistry,
			"visited_hicks_notes": visited_hicks_notes
		},
		"npc_rewards": npc_rewards
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
			
		if "abilities_levels" in player_data:
			abilities_levels = player_data.abilities_levels
		
		if "study_tokens" in player_data:
			study_tokens = player_data.study_tokens
		
		if "achievements_unlocked" in player_data:
			achievements_unlocked = player_data.achievements_unlocked
		
		if "permanent_strength" in player_data:
			permanent_strength = player_data.permanent_strength
			
		if "max_health" in player_data:
			max_health = player_data.max_health
			
		if "ready_to_complete" in player_data:
			ready_to_complete = player_data.ready_to_complete.duplicate()
			for quest_name in ready_to_complete:
				QuestManager.mark_ready_to_complete(quest_name)
				
		if "permanent_speed" in player_data:
			permanent_speed = player_data.permanent_speed
			
		if "brilliant_chance_bonus" in player_data:
			brilliant_chance_bonus = player_data.brilliant_chance_bonus
			
		if "move_data" in data:
			var move_data = data["move_data"]
			move_forward_count = move_data.get("move_forward_count", 0)
			move_backward_count = move_data.get("move_backward_count", 0)
			move_left_count = move_data.get("move_left_count", 0)
			move_right_count = move_data.get("move_right_count", 0)
		
		if "visited_locations" in player_data:
			var visited = player_data["visited_locations"]
			visited_walc = visited.get("visited_walc", false)
			visited_hicks = visited.get("visited_hicks", false)
			visited_armstrong = visited.get("visited_armstrong", false)
			visited_lilly = visited.get("visited_lilly", false)
			visited_vet = visited.get("visited_vet", false)
			visited_fountain = visited.get("visited_fountain", false)
			visited_union = visited.get("visited_union", false)
			visited_belltower = visited.get("visited_belltower", false)
			visited_mall = visited.get("visited_mall", false)
			visited_corec = visited.get("visited_corec", false)
			visited_cs = visited.get("visited_cs", false)
			visited_physics = visited.get("visited_physics", false)
			visited_chemistry = visited.get("visited_chemistry", false)
			visited_hicks_notes = visited.get("visited_hicks_notes", false)
			
		if "active_potion_type" in player_data:
			active_potion_type = player_data.active_potion_type
		if "active_speed_boost" in player_data:
			active_speed_boost = player_data.active_speed_boost
		if "temp_strength_bonus" in player_data:
			temp_strength_bonus = player_data.temp_strength_bonus
			
		if "npc_rewards" in data:
			npc_rewards = data.npc_rewards
			
		if "enemies_defeated" in player_data:
			enemies_defeated = player_data.enemies_defeated

			
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
	position = Vector2(781, 546)
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
	ready_to_complete = []
	defeated_enemies = []
	abilities_levels = [0, 0, 0, -1, -1, -1, -1]
	study_tokens = 7
	achievements_unlocked = [false, false, false, false, false, false, false, false, false, false, false, false]
	
	#Key Binding Defaults
	inventory_key = 69
	move_left = 65
	move_right = 68
	move_up = 87
	move_down = 83
	
	permanent_strength = 1
	max_health = 100
	permanent_speed = 0.0
	brilliant_chance_bonus = 0.0
	
	active_potion_type = ""
	active_speed_boost = 0.0
	temp_strength_bonus = 0
	enemies_defeated = 0


	
	#NPC Rewards
	npc_rewards = {
		"npc_drum": false,
		"npc_fountain": false,
		"npc_johnpurdue": false,
		"npc_outskirts": false,
		"npc_outskirts2": false,
		"npc_business": false
	}
	
	SaveManager.set_volume(0.4)



	 
	
static func is_quest_completed(quest_id: String) -> bool:
	return quest_id in completed_quests
	
func mark_enemy_defeated(enemy_name: String):
	if enemy_name not in defeated_enemies:
		defeated_enemies.append(enemy_name)
		print("Defeated Enemies:", defeated_enemies)

func is_enemy_defeated(enemy_name: String) -> bool:
	return enemy_name in defeated_enemies
	
	
