extends Panel

# Using your existing node paths; ensure these exactly match your scene tree.
@onready var title_label       = $VBoxContainer/Title
@onready var name_label        = $VBoxContainer/Name
@onready var damage_label      = $VBoxContainer/"Damage Delt"
@onready var stun_label        = $VBoxContainer/"Stun Chance"
@onready var miss_label        = $VBoxContainer/"Miss Chance"
@onready var crit_label        = $VBoxContainer/"Critical Chance"
@onready var break_label       = $VBoxContainer/"Break Chance"
@onready var rarity_label      = $VBoxContainer/Rarity
@onready var icon_texture_rect = $VBoxContainer/Icon

func update_info(item: Dictionary) -> void:
	if item:
		name_label.text = item.get("name", "Unknown")
		
		if item.has("texture"):
			icon_texture_rect.texture = item["texture"]
			icon_texture_rect.visible = true
		else:
			icon_texture_rect.visible = false
		
		# Distinguish between items (type 0) and potions (type 1)
		if item["type"] == 0:
			colorize_by_rarity(item.get("rarity", "Common"))
			#title_label.text = "WEAPON INFO"
			damage_label.text = "Damage: " + str(item.get("damage", 0))
			stun_label.text   = "Stun Chance: " + str(int(item.get("stun_chance", 0) * 100)) + "%"
			miss_label.text   = "Miss Chance: " + str(int(item.get("miss_chance", 0) * 100)) + "%"
			crit_label.text   = "Crit Chance: " + str(int(item.get("crit_chance", 0) * 100)) + "%"
			break_label.text  = "Break Chance: " + str(int(item.get("break_chance", 0) * 100)) + "%"
			rarity_label.text = "Rarity: " + str(item.get("rarity", "Common"))
		else:
			#title_label.text = "POTION INFO"
			icon_texture_rect.visible = false
			colorize_by_rarity(item.get("rarity", "Common"))
			if item.has("heal_amount"):
				damage_label.text = "Heal Amount: " + str(item["heal_amount"])
			elif item.has("exp_amount"):
				damage_label.text = "EXP Amount: " + str(item["exp_amount"])
			elif item.has("speed_boost"):
				damage_label.text = "Speed Boost: " + str(item["speed_boost"])
			else:
				damage_label.text = "Value: " + str(item.get("value", 0))
			# For potions, clear out the stats that don't apply.
			stun_label.text   = "Rarity: " + str(item.get("rarity", "Common"))
			miss_label.text   = ""
			crit_label.text   = ""
			break_label.text  = ""
			rarity_label.text = ""
	else:
		title_label.text = ""
		name_label.text  = "No Item Selected"
		damage_label.text = ""
		stun_label.text  = ""
		miss_label.text  = ""
		crit_label.text  = ""
		break_label.text = ""
		rarity_label.text = ""
		icon_texture_rect.visible = false

func colorize_by_rarity(rarity: String) -> void:
	var r = rarity.to_lower()
	if ItemDefinitions.RARITY_COLORS.has(r):
		var color = ItemDefinitions.RARITY_COLORS[r]
		# Apply a theme color override to the name_label.
		name_label.add_theme_color_override("font_color", color)
	else:
		name_label.add_theme_color_override("font_color", Color.WHITE)
