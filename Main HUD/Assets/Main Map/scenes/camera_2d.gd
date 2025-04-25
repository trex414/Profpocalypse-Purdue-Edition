extends Camera2D

@export var move_speed := 400.0  # Adjust movement speed
@export var zoom_speed := 0.1  # Speed of zooming in/out
@export var min_zoom := Vector2(0.5, 0.5)  # Minimum zoom level
@export var max_zoom := Vector2(2, 2)  # Maximum zoom level

func _process(delta):
	var move_direction = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		move_direction.x += 1
	if Input.is_action_pressed("move_left"):
		move_direction.x -= 1
	if Input.is_action_pressed("move_down"):
		move_direction.y += 1
	if Input.is_action_pressed("move_up"):
		move_direction.y -= 1

	position += move_direction.normalized() * move_speed * delta
	
	# Zoom controls (mouse wheel)
	if Input.is_action_just_pressed("zoom_in"):
		zoom = (zoom - Vector2(zoom_speed, zoom_speed)).clamp(min_zoom, max_zoom)
	elif Input.is_action_just_pressed("zoom_out"):
		zoom = (zoom + Vector2(zoom_speed, zoom_speed)).clamp(min_zoom, max_zoom)

	
