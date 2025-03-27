# ItemDefinitions.gd
extends Node

const ITEM_DEFINITIONS = {
	"Pickaxe": {
		"type": 0,  # Assuming ItemType.ITEM is 0
		"name": "Pickaxe",
		"texture_path": "res://Inventory/assets/Pickaxe.jpg",
		"stackable": false,
		"count": 1,
		"damage": 2,
		"stun_chance": 0.0,
		"miss_chance": 0.00,
		"crit_chance": 0.10,
		"break_chance": 0.00
	},
	"Axe": {
		"type": 0,
		"name": "Axe",
		"texture_path": "res://Inventory/assets/Axe.png",
		"stackable": false,
		"count": 1,
		"damage": 10,
		"stun_chance": 0.15,
		"miss_chance": 0.10,
		"crit_chance": 0.15,
		"break_chance": 0.10
	}
}

const SPELL_DEFINITIONS = {
	"Health Potion": {
		"type": 1,  # Assuming ItemType.SPELL is 1
		"name": "Health Potion",
		"texture_path": "res://Inventory/assets/heal.png",
		"stackable": true,
		"count": 1,
		"heal_amount": 3
	},
	"Speed Potion": {
		"type": 1,
		"name": "Speed Potion",
		"texture_path": "res://Inventory/assets/speed.png",
		"stackable": true,
		"count": 1,
		"speed_boost": 10
	},
	"EXP Potion": {
		"type": 1,
		"name": "EXP Potion",
		"texture_path": "res://Inventory/assets/Experience.png",
		"stackable": true,
		"count": 1,
		"exp_amount": 1
	}
}
