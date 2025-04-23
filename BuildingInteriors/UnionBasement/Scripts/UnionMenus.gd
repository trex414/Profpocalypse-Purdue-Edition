extends Node2D

@onready var CloseButton = $CanvasLayer/Panel/CloseButton
var btn = [null, null, null, null, null, null, null, null]
var inventory = null
var notEnough = null
var purchased = null
@onready var PurchasedCloseButton = $CanvasLayer/Purchased/CloseButton
@onready var NotEnoughCloseButton = $CanvasLayer/NotEnough/CloseButton


func _ready():
	$Area2D.mouse_entered.connect(_on_mouse_entered)
	$Area2D.mouse_exited.connect(_on_mouse_exited)
	CloseButton.pressed.connect(toggle_purchase_screen)
	PurchasedCloseButton.pressed.connect(toggle_purchased)
	NotEnoughCloseButton.pressed.connect(toggle_notEnough)
	notEnough = $CanvasLayer/NotEnough
	purchased = $CanvasLayer/Purchased
	for i in range(1, 8):  # 1 through 7
		var button_name = "CanvasLayer/Panel/GridContainer/Button" + str(i)
		btn[i] = get_node_or_null(button_name)
		if btn[i]:
			btn[i].pressed.connect(_on_add_button_pressed.bind(i))
			print("Connected", button_name)
	inventory = get_tree().current_scene.find_child("Control - Inventory", true, false)
	$Panel.visible = false
	await get_tree().process_frame

func _process(_delta):
	if $Panel.visible:
		$Panel.global_position = get_global_mouse_position() + Vector2(10, 10)

func _on_mouse_entered():
	$Panel.visible = true

func _on_mouse_exited():
	$Panel.visible = false

func toggle_purchase_screen():
	print("toggling")
	$CanvasLayer.visible = !$CanvasLayer.visible
	if $CanvasLayer.visible:
		$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
		match self.name:
			"WalkOns":
				print("WalkOns")
			"SushiBoss":
				print("SushiBoss")
			"TendersLoveAndChicken":
				print("TendersLoveAndChicken")
			"RoseMarket":
				print("RoseMarket")
			"BurgersAndFries":
				print("BurgersAndFries")
			"Zen":
				print("Zen")
func toggle_notEnough():
	notEnough.visible = !notEnough.visible
	
func toggle_purchased():
	purchased.visible = !purchased.visible
	

func _on_add_button_pressed(button_number):
	print("You clicked Button", button_number, "on", self.name)
	match self.name:
		"WalkOns":
			match button_number:
				1:
					print("Small Speed Potion")
					if PlayerData.study_tokens >= 1:
						inventory.add_named_item("Small Speed Potion")
						PlayerData.study_tokens -= 1
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				2:
					print("Medium Speed Potion")
					if PlayerData.study_tokens >= 2:
						inventory.add_named_item("Medium Speed Potion")
						PlayerData.study_tokens -= 2
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				3:
					print("Large Speed Potion")
					if PlayerData.study_tokens >= 3:
						inventory.add_named_item("Large Speed Potion")
						PlayerData.study_tokens -= 3
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				4:
					print("WingsOfZephyr")
					if PlayerData.study_tokens >= 5:
						inventory.add_named_item("Wings of Zephyr")
						PlayerData.study_tokens -= 5
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
		"SushiBoss":
			print("SushiBoss clicked Button", button_number)
			match button_number:
				1:
					print("pickaxe")
					if PlayerData.study_tokens >= 1:
						inventory.add_named_item("Pickaxe")
						PlayerData.study_tokens -= 1
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				2:
					print("axe")
					if PlayerData.study_tokens >= 1:
						inventory.add_named_item("Axe")
						PlayerData.study_tokens -= 1
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				3:
					print("Spiked Mace")
					if PlayerData.study_tokens >= 3:
						inventory.add_named_item("Spiked Mace")
						PlayerData.study_tokens -= 3
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				4:
					print("Flame Dagger")
					if PlayerData.study_tokens >= 3:
						inventory.add_named_item("Flame Dagger")
						PlayerData.study_tokens -= 3
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				5:
					print("Stormcaller Wand")
					if PlayerData.study_tokens >= 5:
						inventory.add_named_item("Stormcaller Wand")
						PlayerData.study_tokens -= 5
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				6:
					print("Sword of Truth")
					if PlayerData.study_tokens >= 5:
						inventory.add_named_item("Sword of Truth")
						PlayerData.study_tokens -= 5
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
		"TendersLoveAndChicken":
			print("TendersLoveAndChicken clicked Button", button_number)
			match button_number:
				1:
					print("Rusty Sword")
					if PlayerData.study_tokens >= 1:
						inventory.add_named_item("Rusty Sword")
						PlayerData.study_tokens -= 1
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				2:
					print("Wooden Spear")
					if PlayerData.study_tokens >= 1:
						inventory.add_named_item("Wooden Spear")
						PlayerData.study_tokens -= 1
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				3:
					print("Shortbow")
					if PlayerData.study_tokens >= 3:
						inventory.add_named_item("Shortbow")
						PlayerData.study_tokens -= 3
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				4:
					print("Chilling Staff")
					if PlayerData.study_tokens >= 3:
						inventory.add_named_item("Chilling Staff")
						PlayerData.study_tokens -= 3
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				5:
					print("Hammer of the Titans")
					if PlayerData.study_tokens >= 5:
						inventory.add_named_item("Hammer of the Titans")
						PlayerData.study_tokens -= 5
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				6:
					print("Bow of Infinity")
					if PlayerData.study_tokens >= 5:
						inventory.add_named_item("Bow of Infinity")
						PlayerData.study_tokens -= 5
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				7:
					print("Staff of Elements")
					if PlayerData.study_tokens >= 7:
						inventory.add_named_item("Staff of Elements")
						PlayerData.study_tokens -= 7
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
		"RoseMarket":
			print("RoseMarket clicked Button", button_number)
			match button_number:
				1:
					print("Small Health Potion")
					if PlayerData.study_tokens >= 1:
						inventory.add_named_item("Small Health Potion")
						PlayerData.study_tokens -= 1
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				2:
					print("Medium Health Potion")
					if PlayerData.study_tokens >= 2:
						inventory.add_named_item("Medium Health Potion")
						PlayerData.study_tokens -= 2
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				3:
					print("Large Health Potion")
					if PlayerData.study_tokens >= 3:
						inventory.add_named_item("Large Health Potion")
						PlayerData.study_tokens -= 3
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				4:
					print("Legendary Health Potion")
					if PlayerData.study_tokens >= 5:
						inventory.add_named_item("Legendary Health Potion")
						PlayerData.study_tokens -= 5
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				5:
					print("Elixir of Life")
					if PlayerData.study_tokens >= 7:
						inventory.add_named_item("Elixir of Life")
						PlayerData.study_tokens -= 7
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
		"BurgersAndFries":
			print("BurgersAndFries clicked Button", button_number)
			match button_number:
				1:
					print("small strength")
					if PlayerData.study_tokens >= 1:
						inventory.add_named_item("Small Strength Potion")
						PlayerData.study_tokens -= 1
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				2:
					print("medium strength")
					if PlayerData.study_tokens >= 2:
						inventory.add_named_item("Medium Strength Potion")
						PlayerData.study_tokens -= 2
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				3:
					print("large strength")
					if PlayerData.study_tokens >= 3:
						inventory.add_named_item("Large Strength Potion")
						PlayerData.study_tokens -= 3
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				4:
					print("Titan’s Fury Elixir")
					if PlayerData.study_tokens >= 5:
						inventory.add_named_item("Titan’s Fury Elixir")
						PlayerData.study_tokens -= 5
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				5:
					print("Legendary Damage Potion")
					if PlayerData.study_tokens >= 5:
						inventory.add_named_item("Legendary Damage Potion")
						PlayerData.study_tokens -= 5
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
		"Zen":
			print("Zen clicked Button", button_number)
			match button_number:
				1:
					print("Small EXP Potion")
					if PlayerData.study_tokens >= 1:
						inventory.add_named_item("Small EXP Potion")
						PlayerData.study_tokens -= 1
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				2:
					print("Medium EXP Potion")
					if PlayerData.study_tokens >= 2:
						inventory.add_named_item("Medium EXP Potion")
						PlayerData.study_tokens -= 2
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				3:
					print("Large EXP Potion")
					if PlayerData.study_tokens >= 3:
						inventory.add_named_item("Large EXP Potion")
						PlayerData.study_tokens -= 3
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
				4:
					print("Legendary EXP Potion")
					if PlayerData.study_tokens >= 5:
						inventory.add_named_item("Legendary EXP Potion")
						PlayerData.study_tokens -= 5
						$CanvasLayer/Panel/Label.text = "Study Tokens: " + str(PlayerData.study_tokens)
						toggle_purchased()
					else:
						toggle_notEnough()
