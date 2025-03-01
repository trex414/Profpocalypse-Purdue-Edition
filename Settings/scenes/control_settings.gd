extends Control

@onready var save_button = $"Panel/VBoxContainer/Save Button"
@onready var delete_button = $"Panel/VBoxContainer/Delete Button"
@onready var close_button = $"Panel/VBoxContainer/Close Menu"
@onready var keybind_menu_button = $"Panel/VBoxContainer/Key Binds Button"
@onready var keybind_menu = $"Panel/VBoxContainer/Control - Key Bind Menu"
@onready var close_keybind_button = $"Panel/VBoxContainer/Control - Key Bind Menu/Panel/VBoxContainer/Close Keybind Menu"
@onready var delete_confirm_dialog = $DeleteConfirmation
@onready var HUD_settings_button = $"../Menu Button"

var is_open = false
var keybind_menu_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	keybind_menu.visible = false
	save_button.pressed.connect(_on_save)
	delete_button.pressed.connect(_on_delete)
	close_button.pressed.connect(toggle_menu)
	keybind_menu_button.pressed.connect(toggle_keybind_menu)
	close_keybind_button.pressed.connect(_on_CloseMenuButton_pressed)



func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		toggle_menu()
		

func toggle_menu():
	if self.visible:
		# Close the menu first, then toggle the HUD button
		self.visible = false
		
		# Now hide the HUD button
		HUD_settings_button.visible = true
	else:
		# Show the menu first
		self.visible = true
		
		# Hide the HUD button
		HUD_settings_button.visible = false

	is_open = !is_open
	#get_tree().paused = is_open    # ADD THIS TO PAUSE GAME WHEN SETTINGS IS OPEN
	
	if not is_open:
		keybind_menu.visible = false
		keybind_menu_open = false

func _on_save():
	SaveManager.save()
	
func _on_delete():
	delete_confirm_dialog.popup_centered()
	#SaveManager.delete()

func _on_delete_confirmation_confirmed():
	SaveManager.delete()
	get_tree().quit()  # Close the game
	
func toggle_keybind_menu():
	keybind_menu_open = !keybind_menu_open
	keybind_menu.visible = keybind_menu_open
	
func _on_CloseMenuButton_pressed():
	keybind_menu.visible = false
	keybind_menu_open = !keybind_menu_open
	
