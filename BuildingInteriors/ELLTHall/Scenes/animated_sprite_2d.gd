extends AnimatedSprite2D


var speed = 100  # pixels per second


func _ready():
	play("new")

func _process(delta):
	position.y += speed * delta
	# Reset to left side if it goes off-screen
	if position.y > get_viewport_rect().size.y + 50:
		position.y = -50
