extends Area2D

@onready var exitpop = $"../UI/Control"
@onready var exitpoplabel = $"../../UI/Control/Panel/Label"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		exitpoplabel.text = ("Do you wish to exit?")
		exitpop.show()
