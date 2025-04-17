extends CharacterBody2D

@export var speed: float = 200  # Movement speed

func _ready():
	position = PlayerData.building_interior_position
	
	var last_character_file = FileAccess.open("res://CharacterCustomization/last_saved_character.json", FileAccess.READ)
	var last_character_data = JSON.parse_string(last_character_file.get_as_text())
	last_character_file.close()
	load_character(last_character_data["name"])
	
func load_character(character_name):
	var file = FileAccess.open("res://CharacterCustomization/CustomCharacters/" + character_name + ".json", FileAccess.READ)
	var save_data = JSON.parse_string(file.get_as_text())
	file.close()

	$body_root/face.texture = load(save_data["face_texture"])
	$body_root/face/features.texture = load(save_data["features_texture"])
	$body_root/face/features/hair.texture = load(save_data["hair_texture"])
	$body_root/shirt.texture = load(save_data["shirt_texture"])
	$body_root/pant.texture = load(save_data["pant_texture"])
	$body_root/pant/pant2.texture = load(save_data["pant2_texture"])
	$body_root/pant/pant2/shoe.texture = load(save_data["shoe1_texture"])
	$body_root/pant/pant2/shoe2.texture = load(save_data["shoe2_texture"])
	$body_root/sleeve.texture = load(save_data["arm_texture"])
	$body_root/sleeve/sleeve2.texture = load(save_data["arm2_texture"])
	$body_root/sleeve/sleeve2/hand.texture = load(save_data["hand_texture"])
	$body_root/sleeve/sleeve2/hand2.texture = load(save_data["hand2_texture"])
	$body_root/shirt/neck.texture = load(save_data["neck_texture"])
	$body_root/pant/pant2/belt.texture = load(save_data["belt_texture"])
	$body_root/shirt/class.texture = load(save_data["class_texture"])
	

	

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
