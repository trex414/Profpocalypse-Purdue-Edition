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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Player data variables (initialized but not hardcoded)
var position: Vector2
var inventory: Array
var item_bar: Array
var potion_bar: Array
var level: int
var exp: int
var health: int


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


	# Function to load data on startup
func load_on_start():
	SaveManager.load()

	# Function to set default values only if no save is found
func set_default_values():
	print("No save detected ==========>>>>")
	position = Vector2(0, 0)
	inventory = []
	
	item_bar = []
	item_bar.clear()
	item_bar.resize(5)
	item_bar.fill({})
	
	potion_bar = []
	potion_bar.clear()
	potion_bar.resize(5)
	potion_bar.fill({})
	
	level = 1
	exp = 0
	health = 100
