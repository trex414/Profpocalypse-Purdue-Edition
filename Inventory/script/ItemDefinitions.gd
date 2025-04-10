# ItemDefinitions.gd
extends Node

# Rarity Color Mapping for UI Purposes:
const RARITY_COLORS = {
	"common": Color(0.75, 0.75, 0.75),    # Gray
	"uncommon": Color(0.0, 1.0, 0.0),       # Green
	"rare": Color(0.0, 0.5, 1.0),           # Blue
	"epic": Color(0.5, 0.0, 1.0),           # Purple
	"legendary": Color(1.0, 0.65, 0.0)      # Orange
}

const ITEM_DEFINITIONS = {
	#Common
	"Pickaxe": {
		"type": 0,  # Assuming ItemType.ITEM is 0
		"name": "Pickaxe",
		"texture_path": "res://Inventory/assets/Weapons/Pickaxe.png",
		"stackable": false,
		"count": 1,
		"damage": 4,
		"stun_chance": 0.0,
		"miss_chance": 0.00,
		"crit_chance": 0.00,
		"break_chance": 0.00,
		"rarity": "common"  # Typically common
	},
	"Axe": {
		"type": 0,
		"name": "Axe",
		"texture_path": "res://Inventory/assets/Weapons/Axe.png",
		"stackable": false,
		"count": 1,
		"damage": 10,
		"stun_chance": 0.00,
		"miss_chance": 0.00,
		"crit_chance": 0.12,
		"break_chance": 0.15,
		"rarity": "common"
	},
	"Rusty Sword": {
		"type": 0,
		"name": "Rusty Sword",
		"texture_path": "res://Inventory/assets/Weapons/Rusty Sword.png",
		"stackable": false,
		"count": 1,
		"damage": 15,
		"stun_chance": 0.0,
		"miss_chance": 0.00,
		"crit_chance": 0.25,
		"break_chance": 0.70,
		"rarity": "common"
	},

	"Wooden Spear": {
		"type": 0,
		"name": "Wooden Spear",
		"texture_path": "res://Inventory/assets/Weapons/Wooden Spear.png",
		"stackable": false,
		"count": 1,
		"damage": 7,
		"stun_chance": 0.00,
		"miss_chance": 0.30,
		"crit_chance": 0.30,
		"break_chance": 0.20,
		"rarity": "common"
	},
	#Uncommon
	"Spiked Mace": {
		"type": 0,
		"name": "Spiked Mace",
		"texture_path": "res://Inventory/assets/Weapons/Spiked Mace.png",
		"stackable": false,
		"count": 1,
		"damage": 13,
		"stun_chance": 0.12,
		"miss_chance": 0.10,
		"crit_chance": 0.40,
		"break_chance": 0.40,
		"rarity": "uncommon"
	},
	"Flame Dagger": {
		"type": 0,
		"name": "Flame Dagger",
		"texture_path": "res://Inventory/assets/Weapons/Flame Dagger.png",
		"stackable": false,
		"count": 1,
		"damage": 15,
		"stun_chance": 0.00,
		"miss_chance": 0.00,
		"crit_chance": 0.30,
		"break_chance": 0.40,
		"rarity": "uncommon"

	},
	"Shortbow": {
		"type": 0,
		"name": "Shortbow",
		"texture_path": "res://Inventory/assets/Weapons/Shortbow.png",
		"stackable": false,
		"count": 1,
		"damage": 18,
		"stun_chance": 0.00,
		"miss_chance": 0.50,
		"crit_chance": 0.10,
		"break_chance": 0.15,
		"rarity": "uncommon"
	},
	"Chilling Staff": {
		"type": 0,
		"name": "Chilling Staff",
		"texture_path": "res://Inventory/assets/Weapons/Chilling Staff.png",
		"stackable": false,
		"count": 1,
		"damage": 14,
		"stun_chance": 0.50,
		"miss_chance": 0.25,
		"crit_chance": 0.10,
		"break_chance": 0.30,
		"rarity": "uncommon"
	},
	#rare
		"Stormcaller Wand": {
		"type": 0,
		"name": "Stormcaller Wand",
		"texture_path": "res://Inventory/assets/Weapons/Stormcaller Wand.png",
		"stackable": false,
		"count": 1,
		"damage": 18,
		"stun_chance": 0.10,
		"miss_chance": 0.25,
		"crit_chance": 0.25,
		"break_chance": 0.20,
		"rarity": "rare"
		#"element_type": "lightning",
		#"special_effect": "Shock: Occasionally stuns or deals bonus lightning damage."
	},
	"Sword of Truth": {
		"type": 0,
		"name": "Sword of Truth",
		"texture_path": "res://Inventory/assets/Weapons/Sword of Truth.png",
		"stackable": false,
		"count": 1,
		"damage": 23,
		"stun_chance": 0.10,
		"miss_chance": 0.10,
		"crit_chance": 0.30,
		"break_chance": 0.10,
		"rarity": "rare"
	},
	"Hammer of the Titans": {
		"type": 0,
		"name": "Hammer of the Titans",
		"texture_path": "res://Inventory/assets/Weapons/Hammer of the Titans.png",
		"stackable": false,
		"count": 1,
		"damage": 55,
		"stun_chance": 0.80,
		"miss_chance": 0.20,
		"crit_chance": 0.50,
		"break_chance": 0.50,
		"rarity": "rare"
		#"element_type": "earth",
		#"special_effect": "Shockwave: Has a chance to deal area damage."
	},
	"Dagger of Shadows": {
		"type": 0,
		"name": "Dagger of Shadows",
		"texture_path": "res://Inventory/assets/Weapons/Dagger of Shadows.png",
		"stackable": false,
		"count": 1,
		"damage": 20,
		"stun_chance": 0.05,
		"miss_chance": 0.15,
		"crit_chance": 0.50,
		"break_chance": 0.20,
		"rarity": "epic"
		#"element_type": "dark",
		#"special_effect": "Bleeding: High crit chance inflicts a bleeding effect over time."
	},
	"Bow of Infinity": {
		"type": 0,
		"name": "Bow of Infinity",
		"texture_path": "res://Inventory/assets/Weapons/Bow of Infinity.png",
		"stackable": false,
		"count": 1,
		"damage": 27,
		"stun_chance": 0.10,
		"miss_chance": 0.30,
		"crit_chance": 0.25,
		"break_chance": 0.15,
		"rarity": "epic"
		#"element_type": "wind",
		#"special_effect": "Piercing: Arrows can penetrate through multiple enemies."
	},
	"Staff of Elements": {
		"type": 0,
		"name": "Staff of Elements",
		"texture_path": "res://Inventory/assets/Weapons/Staff of Elements.png",
		"stackable": false,
		"count": 1,
		"damage": 65,
		"stun_chance": 0.40,
		"miss_chance": 0.05,
		"crit_chance": 0.30,
		"break_chance": 0.10,
		"rarity": "legendary"
		#"element_type": "mixed",
		#"special_effect": "Elemental Burst: Occasionally casts a random elemental spell."
	}
}

const SPELL_DEFINITIONS = {
	#Basic Potions
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
	},
	# Health Potions: Small, Medium, Large
	"Small Health Potion": {
		"type": 1,  # Potion/Spell type
		"name": "Small Health Potion",
		"texture_path": "res://Inventory/assets/Potions/Small Health Potion.png",
		"stackable": true,
		"count": 1,
		"heal_amount": 5,
		"rarity": "common"  # Typically common
	},
	"Medium Health Potion": {
		"type": 1,
		"name": "Medium Health Potion",
		"texture_path": "res://Inventory/assets/Potions/Medium Health Potion.png",
		"stackable": true,
		"count": 1,
		"heal_amount": 15,
		"rarity": "uncommon"
	},
	"Large Health Potion": {
		"type": 1,
		"name": "Large Health Potion",
		"texture_path": "res://Inventory/assets/Potions/Large Health Potion.png",
		"stackable": true,
		"count": 1,
		"heal_amount": 30,
		"rarity": "rare"
	},
	# Speed Potions: Small, Medium, Large
		"Small Speed Potion": {
		"type": 1,
		"name": "Small Speed Potion",
		"texture_path": "res://Inventory/assets/Potions/Small Speed Potion.png",
		"stackable": true,
		"count": 1,
		"speed_boost": 10,
		"rarity": "common"
	},
	"Medium Speed Potion": {
		"type": 1,
		"name": "Medium Speed Potion",
		"texture_path": "res://Inventory/assets/Potions/Medium Speed Potion.png",
		"stackable": true,
		"count": 1,
		"speed_boost": 30,
		"rarity": "uncommon"
	},
	"Large Speed Potion": {
		"type": 1,
		"name": "Large Speed Potion",
		"texture_path": "res://Inventory/assets/Potions/Large Speed Potion.png",
		"stackable": true,
		"count": 1,
		"speed_boost": 60,
		"rarity": "rare"
	},
	# EXP Potions: Small, Medium, Large
	"Small EXP Potion": {
		"type": 1,
		"name": "Small EXP Potion",
		"texture_path": "res://Inventory/assets/Potions/Small EXP Potion.png",
		"stackable": true,
		"count": 1,
		"exp_amount": 1,
		"rarity": "uncommon"
	},
	"Medium EXP Potion": {
		"type": 1,
		"name": "Medium EXP Potion",
		"texture_path": "res://Inventory/assets/Potions/Medium EXP Potion.png",
		"stackable": true,
		"count": 1,
		"exp_amount": 5,
		"rarity": "rare"
	},
	"Large EXP Potion": {
		"type": 1,
		"name": "Large EXP Potion",
		"texture_path": "res://Inventory/assets/Potions/Large EXP Potion.png",
		"stackable": true,
		"count": 1,
		"exp_amount": 10,
		"rarity": "epic"
	},
	# Strength Potions
	"Small Strength Potion": {
		"type": 1,
		"name": "Small Strength Potion",
		"texture_path": "res://Inventory/assets/small_strength.png",
		"stackable": true,
		"count": 1,
		"strength_boost": 3,
		"rarity": "epic"
	},
	"Medium Strength Potion": {
		"type": 1,
		"name": "Medium Strength Potion",
		"texture_path": "res://Inventory/assets/medium_strength.png",
		"stackable": true,
		"count": 1,
		"strength_boost": 7,
		"rarity": "uncommon"
	},
	"Large Strength Potion": {
		"type": 1,
		"name": "Large Strength Potion",
		"texture_path": "res://Inventory/assets/large_strength.png",
		"stackable": true,
		"count": 1,
		"strength_boost": 12,
		"rarity": "legendary"
	},
	
	"Legendary Health Potion": {
		"type": 1,
		"name": "Legendary Health Potion",
		"texture_path": "res://Inventory/assets/Potions/Legendary Health Potion.png",
		"stackable": true,
		"count": 1,
		"heal_amount": 100,
		"rarity": "legendary"
	},
	"Legendary Damage Potion": {
		"type": 1,
		"name": "Legendary Damage Potion",
		"texture_path": "res://Inventory/assets/Potions/Legendary Damage Potion.png",
		"stackable": true,
		"count": 1,
		"damage_amount": 50,
		"rarity": "legendary"
	},
	"Legendary EXP Potion": {
		"type": 1,
		"name": "Legendary EXP Potion",
		"texture_path": "res://Inventory/assets/Potions/Legendary EXP Potion.png",
		"stackable": true,
		"count": 1,
		"exp_amount": 100,
		"rarity": "legendary"
	},
	"Wings of Zephyr": {
		"type": 1,
		"name": "Wings of Zephyr",
		"texture_path": "res://Inventory/assets/Potions/Wings of Zephyr.png",
		"stackable": true,
		"count": 1,
		"speed_boost": 200,
		"rarity": "legendary"
	},
	
	# Existing Unique Potions:
	"Elixir of Life": {
		"type": 1,
		"name": "Elixir of Life",
		"texture_path": "res://Inventory/assets/Potions/elixiroflife.webp",
		"stackable": false,
		"count": 1,
		"heal_amount": 99,
		"rarity": "legendary"  # Extremely rare and powerful
	},
	"Secret (Does Nothing?)": {
		"type": 1,
		"name": "Secret",
		"texture_path": "res://Inventory/assets/Potions/notunlocked.png",
		"stackable": false,
		"count": 1,
		"exp_amount": 20,
		"rarity": "legendary"
	}
}
