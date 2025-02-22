extends Label

func _ready():
	set_process(true)

func _process(delta):
	var player = get_node("../Player")  # Adjust if the Player node path differs
	if player.velocity.length() > 0:
		hide()  # Hide the label when the player moves
