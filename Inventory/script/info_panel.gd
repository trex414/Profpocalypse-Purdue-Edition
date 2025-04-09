extends Panel

# Using your existing names/paths; make sure these paths are correct!
@onready var name_label   = $VBoxContainer/Name
@onready var damage_label = $VBoxContainer/"Damage Delt"
@onready var stun_label   = $VBoxContainer/"Stun Chance"
@onready var miss_label   = $VBoxContainer/"Miss Chance"
@onready var crit_label   = $VBoxContainer/"Critical Chance"
@onready var break_label  = $VBoxContainer/"Break Chance"
@onready var rarity_label = $VBoxContainer/Rarity

func update_info(item: Dictionary) -> void:
	if item:
		name_label.text = "Name: " + item.get("name", "Unknown")
		# Distinguish between items (type 0) and potions (type 1)
		if item["type"] == 0:
			# For Items (for example, weapons)
			damage_label.text = "Damage: " + str(item.get("damage", 0))
			stun_label.text   = "Stun Chance: " + str(int(item.get("stun_chance", 0) * 100)) + "%"
			miss_label.text   = "Miss Chance: " + str(int(item.get("miss_chance", 0) * 100)) + "%"
			crit_label.text   = "Crit Chance: " + str(int(item.get("crit_chance", 0) * 100)) + "%"
			break_label.text  = "Break Chance: " + str(int(item.get("break_chance", 0) * 100)) + "%"
			rarity_label.text = "Rarity: " + str(item.get("rarity", "Common"))
		else:
			# For Potions (type 1) – pick one main stat to show.
			# Choose the stat based on what key is present.
			if item.has("heal_amount"):
				damage_label.text = "Heal Amount: " + str(item["heal_amount"])
			elif item.has("exp_amount"):
				damage_label.text = "EXP Amount: " + str(item["exp_amount"])
			elif item.has("speed_boost"):
				damage_label.text = "Speed Boost: " + str(item["speed_boost"])
			else:
				damage_label.text = "Value: " + str(item.get("value", 0))
			# For potions the other stats (stun, miss, crit, break) are not used:
			stun_label.text   = "Rarity: " + str(item.get("rarity", "Common"))
			miss_label.text   = ""
			crit_label.text   = ""
			break_label.text  = ""
			rarity_label.text = ""
	else:
		name_label.text   = "No Item Selected"
		damage_label.text = ""
		stun_label.text   = ""
		miss_label.text   = ""
		crit_label.text   = ""
		break_label.text  = ""
		rarity_label.text = ""
