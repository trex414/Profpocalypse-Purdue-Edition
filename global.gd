extends Node

var tutorial_screen = null

var in_battle: bool = false

var enemy_database = {
	"red": {
		"name": "red",
		"max_health": 100,
		"level": 5,
		"damage": 5,
		"texture_path": "res://User_Battle/Sprites/red.png"
	},
	"blue": {
		"name": "blue",
		"max_health": 100,
		"level": 2,
		"damage": 1,
		"texture_path": "res://User_Battle/Sprites/blue.png"
	},
	"green": {
		"name": "green",
		"max_health": 100,
		"level": 10,
		"damage": 8,
		"texture_path": "res://User_Battle/Sprites/green.png"
	}
}
