extends Control

@onready var save_button = $"Panel/VBoxContainer/Save Button"
@onready var delete_button = $"Panel/VBoxContainer/Delete Button"
@onready var close_button = $"Panel/VBoxContainer/Close Menu"

var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	save_button.pressed.connect(_on_save)
	delete_button.pressed.connect(_on_delete)
	close_button.pressed.connect(toggle_menu)


func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		toggle_menu()
		

func toggle_menu():
	is_open = !is_open
	visible = is_open
	#get_tree().paused = is_open    # ADD THIS TO PAUSE GAME WHEN SETTINGS IS OPEN

func _on_save():
	SaveManager.save()
	
func _on_delete():
	SaveManager.delete()
