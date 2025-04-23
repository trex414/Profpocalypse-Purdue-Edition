extends Node2D

@onready var yesButton = $yesButton
@onready var noButton = $noButton

var person = null

func _ready():
	#name = "Clickable_" + str(randi())  # Or set it in the scene editor
	var area = $Area2D
	area.input_event.connect(_on_area_input)
	yesButton.pressed.connect(purchase_menu)
	noButton.pressed.connect(toggle_dialogue)

	$SpeechBubble.visible = false
	$SpeechText.visible = false
	$yesButton.visible = false
	$noButton.visible = false

func _on_area_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		toggle_dialogue()
		print("You clicked on:", self.name)
		person = self.name

				
func toggle_dialogue():
	$SpeechBubble.visible = !$SpeechBubble.visible
	$SpeechText.visible = !$SpeechText.visible
	$yesButton.visible = !$yesButton.visible
	$noButton.visible = !$noButton.visible

func purchase_menu():
	toggle_dialogue()
	print("purchase from ")
	print(str(person))
	match self.name:
		"BurgerEmployee1":
			print("clicked on Person1")
			get_tree().current_scene.find_child("BurgersAndFries", true, false).toggle_purchase_screen()
		"BurgerEmployee2":
			print("clicked on Person2")
			get_tree().current_scene.find_child("BurgersAndFries", true, false).toggle_purchase_screen()
		"RoseEmployee1":
			print("clicked on Person3")
			get_tree().current_scene.find_child("RoseMarket", true, false).toggle_purchase_screen()
		"RoseEmployee2":
			print("clicked on Person4")
			get_tree().current_scene.find_child("RoseMarket", true, false).toggle_purchase_screen()
		"SushiEmployee1":
			print("clicked on Person5")
			get_tree().current_scene.find_child("SushiBoss", true, false).toggle_purchase_screen()
		"SushiEmployee2":
			print("clicked on Person6")
			get_tree().current_scene.find_child("SushiBoss", true, false).toggle_purchase_screen()
		"SushiEmployee3":
			print("clicked on Person7")
			get_tree().current_scene.find_child("SushiBoss", true, false).toggle_purchase_screen()
		"TendersEmployee1":
			print("clicked on Person8")
			get_tree().current_scene.find_child("TendersLoveAndChicken", true, false).toggle_purchase_screen()
		"TendersEmployee2":
			print("clicked on Person9")
			get_tree().current_scene.find_child("TendersLoveAndChicken", true, false).toggle_purchase_screen()
		"TendersEmployee3":
			print("clicked on Person10")
			get_tree().current_scene.find_child("TendersLoveAndChicken", true, false).toggle_purchase_screen()
		"WalkOnsEmployee1":
			print("clicked on Person11")
			get_tree().current_scene.find_child("WalkOns", true, false).toggle_purchase_screen()
		"WalkOnsEmployee2":
			print("clicked on Person12")
			get_tree().current_scene.find_child("WalkOns", true, false).toggle_purchase_screen()
		"WalkOnsEmployee3":
			print("clicked on Person13")
			get_tree().current_scene.find_child("WalkOns", true, false).toggle_purchase_screen()
		"ZenEmployee1":
			print("clicked on Person14")
			get_tree().current_scene.find_child("Zen", true, false).toggle_purchase_screen()
		"ZenEmployee2":
			print("clicked on Person15")
			get_tree().current_scene.find_child("Zen", true, false).toggle_purchase_screen()
		"ZenEmployee3":
			print("clicked on Person16")
			get_tree().current_scene.find_child("Zen", true, false).toggle_purchase_screen()
