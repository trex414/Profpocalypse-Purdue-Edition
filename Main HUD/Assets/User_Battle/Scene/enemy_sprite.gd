extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func defeat():
	var enemy = get_parent()  # Get the enemy node
	enemy.visible = false  # Hide sprite
	enemy.set_process(false)  # Stop processing input/updates
