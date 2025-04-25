extends Control

@onready var root_node = get_tree().current_scene
@onready var volume_slider = $"Panel/VBoxContainer/Volume Slider"
@onready var brightness_slider = $"Panel/VBoxContainer/Brightness Slider"

var volume_reduction_db: float = -20.0
var bus_name: String = "Master"

# Called when the node enters the scene tree for the first time.
func _ready():
	volume_slider.value = SaveManager.volume 
	volume_slider.connect("value_changed", _on_volume_changed)
	brightness_slider.value = SaveManager.brightness
	brightness_slider.connect("value_changed", _on_brightness_changed)
	
	var bus_index = AudioServer.get_bus_index(bus_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_close_button_pressed():
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, GlobalPreferences.user_defined_volume + volume_reduction_db) # Lower volume
	print(AudioServer.get_bus_volume_db(bus_index))
	queue_free()  # Closes the Preferences window
	
func _on_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))
	SaveManager.set_volume(value)
	GlobalPreferences.user_defined_volume = value;
	print(GlobalPreferences.user_defined_volume)
	
func _on_brightness_changed(brightness):
	root_node.modulate = Color(brightness, brightness, brightness, 1)
	SaveManager.set_brightness(brightness)
