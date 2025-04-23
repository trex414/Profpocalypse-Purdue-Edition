extends Node2D

@onready var CloseButton = $CanvasLayer/Panel/CloseButton


func _ready():
	$Area2D.mouse_entered.connect(_on_mouse_entered)
	$Area2D.mouse_exited.connect(_on_mouse_exited)
	CloseButton.pressed.connect(toggle_purchase_screen)

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
