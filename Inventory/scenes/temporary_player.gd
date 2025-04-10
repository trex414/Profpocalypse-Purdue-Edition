extends CharacterBody2D

@export var base_speed: float = 200  # Default speed
var current_speed: float = 200       # Modifiable speed from potions

# Potion-related
var active_speed = null
var speed_timer = null
var speed_queue = []

func _ready():
	position = PlayerData.position

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

	velocity = direction.normalized() * current_speed

	move_and_slide()
	
	PlayerData.position = position

	if is_moving:
		if not $WalkSFX.playing:
			$WalkSFX.play()
	else:
		$WalkSFX.stop()
		
func apply_speed_boost(boost: float, duration: float):
	var hud = get_node("/root/TestMain/Control - HUD")
	if hud and hud.has_method("show_speed_timer"):
		hud.show_speed_timer(duration)



	if active_speed == null:
		active_speed = boost
		current_speed += boost
		print("Speed boost applied:", boost)

		speed_timer = Timer.new()
		speed_timer.one_shot = true
		speed_timer.wait_time = duration
		add_child(speed_timer)

		speed_timer.timeout.connect(func ():
			current_speed -= boost
			print("Speed boost expired:", boost)
			active_speed = null
			speed_timer = null

			if not speed_queue.is_empty():
				var next = speed_queue.pop_front()
				apply_speed_boost(next.boost, next.duration)
		)
		speed_timer.start()

	elif active_speed == boost:
		print("Same boost – extending duration.")
		if speed_timer:
			speed_timer.start(speed_timer.time_left + duration)

	elif boost > active_speed:
		print("Stronger queued.")
		speed_queue.push_front({ "boost": boost, "duration": duration })

	else:
		print("Weaker queued.")
		speed_queue.append({ "boost": boost, "duration": duration })
