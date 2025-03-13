extends Button

@onready var settings_menu = $"../Control - Settings"  # Adjust path as needed

var original_volume: float = 0.0
var volume_reduction_db: float = -20.0  # Reduce by 20 dB when settings are open
var bus_name: String = "Master"

func _ready():
	self.pressed.connect(_on_button_pressed)
	
	# Get the initial volume of the bus
	var bus_index = AudioServer.get_bus_index(bus_name)
	original_volume = AudioServer.get_bus_volume_db(bus_index)

func _on_button_pressed():
	settings_menu.visible = !settings_menu.visible  # Toggle visibility
	
	if settings_menu.visible:
		var bus_index = AudioServer.get_bus_index(bus_name)
		AudioServer.set_bus_volume_db(bus_index, original_volume + volume_reduction_db) # Lower volume
	else:
		var bus_index = AudioServer.get_bus_index(bus_name)
		AudioServer.set_bus_volume_db(bus_index, original_volume) # Restore original volume
	
	self.visible = false
