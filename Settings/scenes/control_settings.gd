extends Control

@onready var save_button = $"Panel/VBoxContainer/Save Button"
@onready var delete_button = $"Panel/VBoxContainer/Delete Button"
@onready var close_button = $"Panel/VBoxContainer/Close Menu"
@onready var keybind_menu_button = $"Panel/VBoxContainer/Key Binds Button"
@onready var keybind_menu = $"Panel/VBoxContainer/Control - Key Bind Menu"
@onready var close_keybind_button = $"Panel/VBoxContainer/Control - Key Bind Menu/Panel/VBoxContainer/Close Keybind Menu"
@onready var delete_confirm_dialog = $DeleteConfirmation
@onready var HUD_settings_button = $"../Menu Button"
@onready var preferences_button = $"Panel/VBoxContainer/Preferences Button"
@onready var quit_button = $"Panel/VBoxContainer/Close Game"
@onready var quit_confirm_dialog = $QuitConfirmation
@onready var tutorial_button = $"Panel/VBoxContainer/Tutorial Button"

var is_open = false
var keybind_menu_open = false
var preferences_menu = null

var original_volume: float = 0.0
var volume_reduction_db: float = -20.0  # Reduce by 20 dB when settings are open
var bus_name: String = "Master"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	keybind_menu.visible = false
	save_button.pressed.connect(_on_save)
	delete_button.pressed.connect(_on_delete)
	close_button.pressed.connect(toggle_menu)
	keybind_menu_button.pressed.connect(toggle_keybind_menu)
	close_keybind_button.pressed.connect(_on_CloseMenuButton_pressed)
	preferences_button.pressed.connect(_on_preferences_button_pressed)
	quit_button.pressed.connect(_on_quit_game)
	tutorial_button.pressed.connect(begin_tutorial)
	
	# Get the initial volume of the bus
	var bus_index = AudioServer.get_bus_index(bus_name)
	print("Ready", GlobalPreferences.user_defined_volume)
	

func begin_tutorial():
	if Global.tutorial_screen:
		Global.tutorial_screen.visible = true
		
	toggle_menu()
	
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		toggle_menu()
		

func toggle_menu():
	#Play SFX
	$MenuClick.play()
	if self.visible:
		# Close the menu first, then toggle the HUD button
		self.visible = false
		
		# Now show the HUD button
		HUD_settings_button.visible = true
		
		var bus_index = AudioServer.get_bus_index(bus_name)
		print("Check 2 ", GlobalPreferences.user_defined_volume)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(GlobalPreferences.user_defined_volume)) # Restore volume
		print(AudioServer.get_bus_volume_db(bus_index))
	else:
		# Show the menu first
		self.visible = true
		
		# Hide the HUD button
		HUD_settings_button.visible = false
		
		var bus_index = AudioServer.get_bus_index(bus_name)
		#GlobalPreferences.user_defined_volume = AudioServer.get_bus_volume_db(bus_index)
		print("Check 1 ", GlobalPreferences.user_defined_volume)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(GlobalPreferences.user_defined_volume) + volume_reduction_db) # Lower volume
		print(AudioServer.get_bus_volume_db(bus_index))

	is_open = !is_open
	#get_tree().paused = is_open    # ADD THIS TO PAUSE GAME WHEN SETTINGS IS OPEN
	
	if not is_open:
		keybind_menu.visible = false
		keybind_menu_open = false

func _on_save():
	SaveManager.save()
	
func _on_delete():
	delete_confirm_dialog.popup_centered()


func _on_delete_confirmation_confirmed():
	SaveManager.delete()
	get_tree().quit()  # Close the game
	
func toggle_keybind_menu():
	keybind_menu_open = !keybind_menu_open
	keybind_menu.visible = keybind_menu_open
	
func _on_CloseMenuButton_pressed():
	keybind_menu.visible = false
	keybind_menu_open = !keybind_menu_open
	
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(GlobalPreferences.user_defined_volume)) # Restore volume
	

func _on_quit_game():
	quit_confirm_dialog.popup_centered()
	
func _on_quit_confirmation_confirmed():
	SaveManager.save()
	get_tree().quit()

	
func _on_preferences_button_pressed():
	if preferences_menu == null:
		preferences_menu = load("res://Settings/scenes/preferences_menu.tscn").instantiate()
		
		var bus_index = AudioServer.get_bus_index(bus_name)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(GlobalPreferences.user_defined_volume)) # Restore original volume

		add_child(preferences_menu)  # Add it to the scene
