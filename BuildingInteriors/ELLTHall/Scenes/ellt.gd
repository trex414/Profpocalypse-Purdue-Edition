extends Node2D

var entered = false
@onready var exitpop = $UI/Control
@onready var exitpoplabel = $UI/Control/Panel/Label

func _on_area_2d_body_entered(body: Node2D) -> void:
	if entered:
		exitpoplabel.text = ("Do you wish to exit?")
		exitpop.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	entered = true
