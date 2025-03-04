extends Control

@onready var volume_slider = $"Panel/VBoxContainer/Volume Slider"


# Called when the node enters the scene tree for the first time.
func _ready():
	volume_slider.value = SaveManager.volume 
	volume_slider.connect("value_changed", _on_volume_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_close_button_pressed():
	queue_free()  # Closes the Preferences window
	
func _on_volume_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	SaveManager.set_volume(value)
