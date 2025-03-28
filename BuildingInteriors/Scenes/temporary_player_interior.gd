extends CharacterBody2D

@export var speed: float = 200  # Movement speed

func _ready():
	position = PlayerData.building_interior_position

func _physics_process(delta):
	var direction = Vector2.ZERO
	var is_moving = false

	if Input.is_action_pressed("move_right"):
		direction.x += 1
		PlayerData.position.x += 1
		is_moving = true
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		PlayerData.position.x -= 1
		is_moving = true
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		PlayerData.position.y += 1
		is_moving = true
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		PlayerData.position.y -= 1
		is_moving = true

	velocity = direction.normalized() * speed
	move_and_slide()
	
	PlayerData.building_interior_position = position

	# Play walking sound
	if is_moving:
		if not $WalkSFX.playing:
			$WalkSFX.play()
	else:
		$WalkSFX.stop()
