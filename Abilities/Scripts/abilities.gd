extends Control

# Ability Dictionary (Only Stores Base Values & Descriptions)
var abilities = {
	"GPA": {
		"description": "Max health",
		"base_value": 10
	},
	"Brownie Points": {
		"description": "Subtracted from damage",
		"base_value": 10
	},
	"Luck": {
		"description": "Subtracted from hit chance",
		"base_value": 10
	},
	"Extra Credit": {
		"description": "HP that renews either each round or each combat. Should only come from items.",
		"base_value": 10
	},
	"Brilliant Answer Chance": {
		"description": "% chance to deal 2x or 1.5x damage",
		"base_value": 10
	},
	"Move Speed": {
		"description": "Affects player movement",
		"base_value": 10
	},
	"Hint Odds": {
		"description": "Chance to receive a cryptic hint",
		"base_value": 10
	},
	"Intelligence": {
		"description": "Reduce number of multiple choices for trivia questions",
		"base_value": 10
	}
}

# Separate Variables to Store Current Values
var GPA = 3
var Brownie_Points = 0
var Luck = 0
var Extra_Credit = 0
var Brilliant_Answer_Chance = 0
var Move_Speed = 0
var Hint_Odds = 0
var Intelligence = 0

@onready var labels_container = $CanvasLayer/VBoxContainer  # Container for labels
@onready var progress_container = $CanvasLayer/VBoxContainer2  # Container for progress bars

func _ready():
	# Initialize UI with current values
	for ability in abilities.keys():
		update_ability(ability, get_current_value(ability))

func update_ability(ability_name, value):
	# Update the corresponding variable
	set_current_value(ability_name, value)

	# Update the label text
	for label in labels_container.get_children():
		if label.name == ability_name:
			label.text = ability_name + ": " + str(value) + "/" + str(abilities[ability_name]["base_value"])

	# Update the progress bar value
	for bar in progress_container.get_children():
		if bar.name == ability_name and bar is ProgressBar:
			bar.value = value

func get_current_value(ability_name):
	match ability_name:
		"GPA": return GPA
		"Brownie Points": return Brownie_Points
		"Luck": return Luck
		"Extra Credit": return Extra_Credit
		"Brilliant Answer Chance": return Brilliant_Answer_Chance
		"Move Speed": return Move_Speed
		"Hint Odds": return Hint_Odds
		"Intelligence": return Intelligence
	return 0  # Default case (should never happen)

func set_current_value(ability_name, value):
	match ability_name:
		"GPA": GPA = value
		"Brownie Points": Brownie_Points = value
		"Luck": Luck = value
		"Extra Credit": Extra_Credit = value
		"Brilliant Answer Chance": Brilliant_Answer_Chance = value
		"Move Speed": Move_Speed = value
		"Hint Odds": Hint_Odds = value
		"Intelligence": Intelligence = value
