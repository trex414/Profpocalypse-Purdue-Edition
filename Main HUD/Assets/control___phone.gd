extends Control

var phone = null
@onready var phoneButton = $Panel/phoneButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phoneButton.pressed.connect(_on_phone_pressed)


func _on_phone_pressed():
	var phone = get_tree().current_scene.find_child("Phone", true, false)
	phone.toggle_Phone()
	
func set_phone(phoneRef: Control):
	phone = phoneRef
