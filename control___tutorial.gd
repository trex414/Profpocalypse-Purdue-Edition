extends Control

var keys_pressed = {
	"move_up": false,
	"move_left": false,
	"move_down": false,
	"move_right": false,
	"inventory_key": false,
	"QuestMenu": false,
	"courses_information": false,
}


@onready var labels = $Panel/VBoxContainer.get_children()

func _ready():
	update_labels()

func _input(event):
	if event.is_action_pressed("move_up"):
		keys_pressed["move_up"] = true
	elif event.is_action_pressed("move_left"):
		keys_pressed["move_left"] = true
	elif event.is_action_pressed("move_down"):
		keys_pressed["move_down"] = true
	elif event.is_action_pressed("move_right"):
		keys_pressed["move_right"] = true
	elif event.is_action_pressed("inventory_key"):
		keys_pressed["inventory_key"] = true
	elif event.is_action_pressed("QuestMenu"):
		keys_pressed["QuestMenu"] = true
	elif event.is_action_pressed("courses_information"):
		keys_pressed["courses_information"] = true
	
	update_labels()
	
	if all_keys_completed():
		labels[-1].text = "Status: ✅ Tutorial Completed!"

func update_labels():
	labels[0].text = "Move Up (W): " + ("[✔]" if keys_pressed["move_up"] else "[ ]")
	labels[1].text = "Move Left (A): " + ("[✔]" if keys_pressed["move_left"] else "[ ]")
	labels[2].text = "Move Down (S): " + ("[✔]" if keys_pressed["move_down"] else "[ ]")
	labels[3].text = "Move Right (D): " + ("[✔]" if keys_pressed["move_right"] else "[ ]")
	labels[4].text = "Open Inventory (E): " + ("[✔]" if keys_pressed["inventory_key"] else "[ ]")
	labels[5].text = "Open Quests (Q): " + ("[✔]" if keys_pressed["QuestMenu"] else "[ ]")
	labels[6].text = "Open Classes (C): " + ("[✔]" if keys_pressed["courses_information"] else "[ ]")

func all_keys_completed() -> bool:
	for key in keys_pressed.values():
		if not key:
			return false
	return true
	
func _process(delta):
		if all_keys_completed() and visible:
			await get_tree().create_timer(2.0).timeout
			Global.tutorial_screen.visible = false
