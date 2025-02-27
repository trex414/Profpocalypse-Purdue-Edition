extends MenuButton



@onready var face_sprite = $/root/CharacterCuztomization/face  
@onready var features_sprite = $/root/CharacterCuztomization/face/features
@onready var hair_sprite = $/root/CharacterCuztomization/face/features/hair


var current_tint_index = 0  # Tracks the current tint selection
func _on_change_face_pressed():
	

	# Cycle through tint folders
	current_tint_index += 1
	if current_tint_index > 7:  # Since we have 8 tints (0 to 7)
		current_tint_index = 0  # Loop back to the first tint

	# Construct the texture path dynamically
	var face_texture_path = "res://kenney_modular-characters/PNG/Skin/Tint " + str(current_tint_index + 1) + "/tint" + str(current_tint_index + 1) + "_head.png"

	# Load the new texture
	var new_texture = load(face_texture_path)

	# Apply the new texture
	face_sprite.texture = new_texture










var current_features_index = 0

func _on_change_features_pressed() -> void:
	# Cycle through available feature options
	
	current_features_index += 1
	if current_features_index > 3:  # Since we have 4 features (0 to 3)
		current_features_index = 0  # Loop back to the first feature

	# Construct the texture path dynamically
	var features_texture_path = "res://kenney_modular-characters/PNG/Face/Completes/face" + str(current_features_index + 1) + ".png"

	# Load the new texture
	var new_texture = load(features_texture_path)

	# Apply the new texture
	features_sprite.texture = new_texture

	

var current_hair_index = 0
func _on_change_hair_pressed() -> void:
	# Cycle through different hairstyles (assuming Black hair folder)
	current_hair_index += 1
	if current_hair_index > 7:  # Adjust based on the number of styles available
		current_hair_index = 0  # Loop back to the first hairstyle

	# Construct the texture path dynamically
	var hair_texture_path = "res://kenney_modular-characters/PNG/Hair/Black/blackMan" + str(current_hair_index + 1) + ".png"

	# Load the new texture
	var new_texture = load(hair_texture_path)

	# Apply the new texture
	hair_sprite.texture = new_texture
