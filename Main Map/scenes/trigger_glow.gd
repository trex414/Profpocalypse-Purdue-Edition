extends Area2D

@onready var sprite := $"../Sprite2D"

func _ready():
	# Ensure Area2D detects mouse input
	input_pickable = true
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered():
	#print("entered interactable!")
	if sprite.material:
		sprite.material.set_shader_parameter("glow_enabled", true)
		#print("enabled glow")

func _on_mouse_exited():
	if sprite.material:
		sprite.material.set_shader_parameter("glow_enabled", false)
