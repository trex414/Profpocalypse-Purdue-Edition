extends Node

var user_defined_volume: float

func _ready() -> void:
	user_defined_volume = SaveManager.volume
