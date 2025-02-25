# Script manages player data. Contains functions to update inventory, position, level, etc. Add whatever information that pertains to the player as we create it.
extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_on_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Player data variables (initialized but not hardcoded)
var position: Vector2
var inventory: Array
var level: int
var exp: int
var health: int


# Function to get current game state (pass this to the save function when saving)
func get_game_state():
	return {
		"player": {
			"position": {"x": position.x, "y": position.y},
			"inventory": inventory,
			"level": level,
			"exp": exp,
			"health": health,
		}
	}

	# Function to apply loaded data (for loading)
func apply_game_state(data):
	position = Vector2(data.player.position.x, data.player.position.y)
	inventory = data.player.inventory
	level = data.player.level
	exp = data.player.exp
	health = data.player.health


	# Function to load data on startup
func load_on_start():
	SaveManager.load()

	# Function to set default values only if no save is found
func set_default_values():
	position = Vector2(0, 0)
	inventory = []
	level = 1
	exp = 0
	health = 100
