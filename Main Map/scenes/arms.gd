extends StaticBody2D

@onready var label = $Label  # Assuming Label is a child of this Area2D

func _ready():
	label.hide()  # Hide label initially
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _process(_delta):
	if label.visible:
		label.global_position = get_global_mouse_position() + Vector2(20, 20)  # Offset from cursor

func _on_mouse_entered():
	label.show()

func _on_mouse_exited():
	label.hide()
