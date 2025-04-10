extends CharacterBody2D

@export var base_speed: float = 200  # Default speed
var current_speed: float = 200       # Modifiable speed from potions

# speed data
var active_speed = null
var speed_timer = null
#strength data
var base_strength: int = 0
var strength_bonus: int = 0  # temporary
var strength_boost_timer: Timer

var active_potion_type := ""  # "speed" or "strength"



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
	if active_potion_type != "":
		print("❌ Cannot use speed potion while any potion is active.")
		return
	
	active_potion_type = "speed"
	active_speed = boost
	current_speed += boost
	print("⚡ Speed boost applied:", boost)

	# Optional: Show timer on HUD
	var hud = get_node("/root/TestMain/Control - HUD")
	if hud and hud.has_method("show_speed_timer"):
		hud.show_speed_timer(duration)

	speed_timer = Timer.new()
	speed_timer.one_shot = true
	speed_timer.wait_time = duration
	add_child(speed_timer)

	speed_timer.timeout.connect(func ():
		current_speed -= boost
		print("⏱️ Speed boost expired:", boost)
		active_speed = null
		speed_timer = null
		active_potion_type = ""  # 🔓 Unlock usage
	)

	speed_timer.start()

func increase_permanent_strength(amount: int):
	base_strength += amount
	print("💪 Permanent strength increased by", amount, "→ Total:", get_total_strength())
	
func apply_strength_boost(temp_amount: int, duration: float):
	if active_potion_type != "" and active_potion_type != "strength":
		print("❌ Cannot use strength potion while another potion is active.")
		return
	active_potion_type = "strength"
	strength_bonus += temp_amount
	print("⚔️ Temporary strength boost +%d for %.1f seconds." % [temp_amount, duration])
	
	var hud = get_node("/root/TestMain/Control - HUD")
	if hud and hud.has_method("show_strength_timer"):
		hud.show_strength_timer(duration)
		
	if strength_boost_timer == null:
		strength_boost_timer = Timer.new()
		strength_boost_timer.one_shot = true
		add_child(strength_boost_timer)
		strength_boost_timer.timeout.connect(_on_strength_boost_timeout)

	strength_boost_timer.stop()
	strength_boost_timer.wait_time = duration
	strength_boost_timer.start()
	
func _on_strength_boost_timeout():
	print("⏱️ Temporary strength boost expired.")
	strength_bonus = 0
	active_potion_type = ""  # 💥 Unlock usage


func get_total_strength() -> int:
	return base_strength + strength_bonus
