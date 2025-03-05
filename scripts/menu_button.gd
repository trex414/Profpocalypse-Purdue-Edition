extends Button

@onready var settings_menu = $"../Control - Settings"  # Adjust path as needed

func _ready():
	print(settings_menu)
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	settings_menu.visible = !settings_menu.visible  # Toggle visibility
	self.visible = false
