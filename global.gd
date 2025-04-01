extends Node

var tutorial_screen = null

var in_battle: bool = false

var enemy_database = {
	"red": {
		"name": "Red",
		"max_health": 100,
		"level": 5,
		"damage": 5,
		"texture_path": "res://User_Battle/Sprites/red.png"
	},
	"blue": {
		"name": "Blue",
		"max_health": 100,
		"level": 2,
		"damage": 1,
		"texture_path": "res://User_Battle/Sprites/blue.png"
	}
}
