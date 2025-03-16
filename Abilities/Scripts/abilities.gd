extends Control

var abilities = {
	"Strength": {
		"description": "Determines physical power and damage.",
		"base_value": 10,  # Can be modified later
		"modifiers": []  # List for future bonuses/effects
	},
	"Speed": {
		"description": "Affects movement and attack speed.",
		"base_value": 10,
		"modifiers": []
	},
	"Endurance": {
		"description": "Increases health and stamina.",
		"base_value": 10,
		"modifiers": []
	},
	"Agility": {
		"description": "Improves dodging and reflexes.",
		"base_value": 10,
		"modifiers": []
	},
	"Intelligence": {
		"description": "Boosts problem-solving and magic effectiveness.",
		"base_value": 10,
		"modifiers": []
	},
	"Perception": {
		"description": "Enhances awareness of surroundings.",
		"base_value": 10,
		"modifiers": []
	},
	"Charisma": {
		"description": "Influences interactions with NPCs and allies.",
		"base_value": 10,
		"modifiers": []
	},
	"Luck": {
		"description": "Affects random events and critical success chances.",
		"base_value": 10,
		"modifiers": []
	}
}

@onready var labels_container = $CanvasLayer/VBoxContainer  # Adjust path
@onready var progress_container = $CanvasLayer/VBoxContainer2  # Adjust path

func _ready():
	update_ability("Speed", 5)
	update_ability("Strength", 5)
	update_ability("Intelligence", 5)

			


func update_ability(ability_name, value):
	for label in labels_container.get_children():
		if label.name == ability_name:
			label.text = str(value) + "/10 " + ability_name 

	for bar in progress_container.get_children():
		if bar is ProgressBar and bar.name == ability_name:
			bar.value = value
