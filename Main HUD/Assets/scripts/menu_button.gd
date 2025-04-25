extends Button

@onready var settings_menu = $"../Control - Settings"
@onready var click = $"../Control - Settings/MenuClick"

var volume_reduction_db: float = -20.0  # Reduce by 20 dB when settings are open
var bus_name: String = "Master"

func _ready():
	self.pressed.connect(_on_button_pressed)
	
	# Get the initial volume of the bus
	var bus_index = AudioServer.get_bus_index(bus_name)

func _on_button_pressed():
	#Play SFX
	click.play();

	settings_menu.visible = !settings_menu.visible  # Toggle visibility
	
	if settings_menu.visible:
		var bus_index = AudioServer.get_bus_index(bus_name)
		print("Check 1 ", GlobalPreferences.user_defined_volume)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(GlobalPreferences.user_defined_volume) + volume_reduction_db) # Lower volume
		print(AudioServer.get_bus_volume_db(bus_index))
	else:
		var bus_index = AudioServer.get_bus_index(bus_name)
		print("Check 2 ", GlobalPreferences.user_defined_volume)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(GlobalPreferences.user_defined_volume)) # Restore volume
		print(AudioServer.get_bus_volume_db(bus_index))
	
	self.visible = false
