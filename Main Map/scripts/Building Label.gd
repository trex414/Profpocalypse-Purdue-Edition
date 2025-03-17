extends Area2D

@onready var label = $Label  # Assuming Label is a child of this Area2D
@onready var enterpop = $"../../UI/Control"
@onready var enterpoplabel = $"../../UI/Control/Panel/Label"

func _ready():
	label.hide()  # Hide label initially
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _process(_delta):
	if enterpop.visible:
		label.hide()
	if label.visible:
		label.global_position = get_global_mouse_position() + Vector2(10, 10)  # Offset from cursor

func _on_mouse_entered():
	label.show()

func _on_mouse_exited():
	label.hide()
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		label.hide()
		enterpoplabel.text = ("Do you wish to enter " + str(label.get_parent().name) + "?")
		enterpop.show()
