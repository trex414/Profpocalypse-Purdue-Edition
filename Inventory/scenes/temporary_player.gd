extends CharacterBody2D

var custom_body = null

@export var base_speed: float = 200
var current_speed: float = 200

var active_speed = null
var speed_timer = null

var base_strength: int = 0
var strength_bonus: int = 0
var strength_boost_timer: Timer

var active_potion_type := ""

func _ready():
	position = PlayerData.position
	print("player position: " + str(position))
	base_strength = PlayerData.permanent_strength
	current_speed = base_speed + PlayerData.permanent_speed
	
	var last_character_file = FileAccess.open("res://CharacterCustomization/last_saved_character.json", FileAccess.READ)
	var last_character_data = JSON.parse_string(last_character_file.get_as_text())
	last_character_file.close()
	load_character(last_character_data["name"])

func load_character(character_name):
	var file = FileAccess.open("res://CharacterCustomization/CustomCharacters/" + character_name + ".json", FileAccess.READ)
	var save_data = JSON.parse_string(file.get_as_text())
	file.close()

	$CharacterVisuals/body_root/face.texture = load(save_data["face_texture"])
	$CharacterVisuals/body_root/face/features.texture = load(save_data["features_texture"])
	$CharacterVisuals/body_root/face/features/hair.texture = load(save_data["hair_texture"])
	$CharacterVisuals/body_root/shirt.texture = load(save_data["shirt_texture"])
	$CharacterVisuals/body_root/pant.texture = load(save_data["pant_texture"])
	$CharacterVisuals/body_root/pant/pant2.texture = load(save_data["pant2_texture"])
	$CharacterVisuals/body_root/pant/pant2/shoe.texture = load(save_data["shoe1_texture"])
	$CharacterVisuals/body_root/pant/pant2/shoe2.texture = load(save_data["shoe2_texture"])
	$CharacterVisuals/body_root/sleeve.texture = load(save_data["arm_texture"])
	$CharacterVisuals/body_root/sleeve/sleeve2.texture = load(save_data["arm2_texture"])
	$CharacterVisuals/body_root/sleeve/sleeve2/hand.texture = load(save_data["hand_texture"])
	$CharacterVisuals/body_root/sleeve/sleeve2/hand2.texture = load(save_data["hand2_texture"])
	$CharacterVisuals/body_root/shirt/neck.texture = load(save_data["neck_texture"])
	$CharacterVisuals/body_root/pant/pant2/belt.texture = load(save_data["belt_texture"])
	$CharacterVisuals/body_root/shirt/class.texture = load(save_data["class_texture"])

func _physics_process(delta):
	var direction = Vector2.ZERO
	var is_moving = false

	if Input.is_action_pressed("move_right"):
		direction.x += 1
		PlayerData.position.x += 1
		PlayerData.move_right_count += 1
		is_moving = true
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		PlayerData.position.x -= 1
		PlayerData.move_left_count += 1
		is_moving = true
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		PlayerData.position.y += 1
		PlayerData.move_backward_count += 1
		is_moving = true
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		PlayerData.position.y -= 1
		PlayerData.move_forward_count += 1
		is_moving = true

	velocity = direction.normalized() * current_speed
	move_and_slide()
	PlayerData.position = position

	# Animate bobbing only while moving
	if is_moving:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("walk_bob")
		if not $WalkSFX.playing:
			$WalkSFX.play()
	else:
		if $AnimationPlayer.is_playing():
			$AnimationPlayer.stop()
			$CharacterVisuals.position.y = 0  # reset position
		$WalkSFX.stop()

func apply_speed_boost(boost: float, duration: float):
	if active_potion_type != "":
		print("❌ Cannot use speed potion while any potion is active.")
		return
	
	active_potion_type = "speed"
	active_speed = boost
	current_speed += boost
	print("⚡ Speed boost applied:", boost)

	# ✅ Sync with PlayerData
	PlayerData.active_potion_type = "speed"
	PlayerData.active_speed_boost = boost

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
		active_potion_type = ""

		# ✅ Clear PlayerData
		PlayerData.active_potion_type = ""
		PlayerData.active_speed_boost = 0.0
	)
	speed_timer.start()


func increase_permanent_speed(amount: float):
	PlayerData.permanent_speed += amount
	current_speed = base_speed + PlayerData.permanent_speed
	print("🚀 Permanent speed increased! Current:", current_speed)

func increase_permanent_strength(amount: int):
	base_strength += amount
	PlayerData.permanent_strength = base_strength
	print("💪 Permanent strength increased by", amount, "→ Total:", get_total_strength())

func apply_strength_boost(temp_amount: int, duration: float):
	if active_potion_type != "" and active_potion_type != "strength":
		print("❌ Cannot use strength potion while another potion is active.")
		return

	active_potion_type = "strength"
	strength_bonus += temp_amount
	print("⚔️ Temporary strength boost +%d for %.1f seconds." % [temp_amount, duration])

	# ✅ Sync with PlayerData
	PlayerData.active_potion_type = "strength"
	PlayerData.temp_strength_bonus = temp_amount

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
	active_potion_type = ""

	# ✅ Clear PlayerData
	PlayerData.active_potion_type = ""
	PlayerData.temp_strength_bonus = 0


func get_total_strength() -> int:
	return base_strength + strength_bonus

func increase_brilliant_chance(amount: float):
	PlayerData.brilliant_chance_bonus += amount
	print("🌟 Brilliant Answer % increased by", amount, "→ Total:", PlayerData.brilliant_chance_bonus)

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass
