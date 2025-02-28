extends MenuButton

@onready var face_sprite = $/root/CharacterCuztomization/body_root/face  
@onready var features_sprite = $/root/CharacterCuztomization/body_root/face/features
@onready var hair_sprite = $/root/CharacterCuztomization/body_root/face/features/hair
@onready var shirt_sprite = $/root/CharacterCuztomization/body_root/shirt
@onready var pant_sprite = $/root/CharacterCuztomization/body_root/pant
@onready var pant2_sprite = $/root/CharacterCuztomization/body_root/pant/pant2
@onready var shoe1_sprite = $/root/CharacterCuztomization/body_root/pant/pant2/shoe
@onready var shoe2_sprite = $/root/CharacterCuztomization/body_root/pant/pant2/shoe2
@onready var arm_sprite = $/root/CharacterCuztomization/body_root/sleeve
@onready var arm2_sprite = $/root/CharacterCuztomization/body_root/sleeve/sleeve2
@onready var hand_sprite = $/root/CharacterCuztomization/body_root/sleeve/sleeve2/hand
@onready var hand2_sprite = $/root/CharacterCuztomization/body_root/sleeve/sleeve2/hand2
@onready var neck_sprite = $/root/CharacterCuztomization/body_root/shirt/neck
@onready var belt_sprite = $/root/CharacterCuztomization/body_root/pant/pant2/belt  
@onready var name_input = $/root/CharacterCuztomization/name
@onready var save_button = $/root/CharacterCuztomization/save

# Indices for cycling through options
var current_tint_index = 0
var current_hair_color_index = 0
var current_hair_style_index = 0
var current_features_index = 0
var current_shirt_index = 0
var current_pant_index = 0
var current_shoe_index = 0

# Lists of available colors
var hair_colors = ["Black", "Blonde", "Brown", "Red", "White"]
var shirt_colors = ["blue", "green", "grey", "navy", "pine", "red", "white", "yellow"]
var pant_colors = ["Brown", "Green", "Grey", "LightBlue", "Navy", "Pine", "Red", "Tan", "White", "Yellow"]
var shoe_colors = ["Black", "Blue", "Brown", "Grey", "Red", "Tan"]


# ---------------- FACE CUSTOMIZATION (TINT) ----------------
func _on_change_face_pressed():
	current_tint_index = (current_tint_index + 1) % 8  # 8 skin tints available
	var tint_folder = "Tint " + str(current_tint_index + 1)
	var face_texture_path = "kenney_modular-characters/PNG/Skin/" + tint_folder + "/tint" + str(current_tint_index + 1) + "_head.png"
	face_sprite.texture = load(face_texture_path)

	# Apply skin tint to neck, arms, and hands
	var skin_texture_path = "kenney_modular-characters/PNG/Skin/" + tint_folder + "/tint" + str(current_tint_index + 1)
	arm_sprite.texture = load(skin_texture_path + "_arm.png")
	arm2_sprite.texture = load(skin_texture_path + "_arm.png")
	hand_sprite.texture = load(skin_texture_path + "_hand.png")
	hand2_sprite.texture = load(skin_texture_path + "_hand.png")
	neck_sprite.texture = load(skin_texture_path + "_neck.png")

# ---------------- FEATURES CUSTOMIZATION ----------------
func _on_change_features_pressed():
	current_features_index = (current_features_index + 1) % 4  # 4 available features
	var features_texture_path = "kenney_modular-characters/PNG/Face/face" + str(current_features_index + 1) + ".png"
	features_sprite.texture = load(features_texture_path)

# ---------------- HAIR CUSTOMIZATION (COLOR + STYLE) ----------------
func _on_change_hair_pressed():
	# Cycle through both color and style in one method
	current_hair_style_index += 1
	if current_hair_style_index >= 3:
		current_hair_style_index = 0
		current_hair_color_index = (current_hair_color_index + 1) % hair_colors.size()

	# Update hair texture
	var hair_color = hair_colors[current_hair_color_index]
	var hair_style = ["5", "7", "8"][current_hair_style_index]
	var hair_texture_path = "kenney_modular-characters/PNG/Hair/" + hair_color + "/" + hair_color.to_lower() + "Man" + hair_style + ".png"
	hair_sprite.texture = load(hair_texture_path)

# ---------------- SHIRT CUSTOMIZATION ----------------
func _on_change_shirt_pressed():
	current_shirt_index = (current_shirt_index + 1) % shirt_colors.size()
	var shirt_texture_path = "kenney_modular-characters/PNG/Shirts/" + shirt_colors[current_shirt_index] + "Shirt7.png"
	shirt_sprite.texture = load(shirt_texture_path)

# ---------------- PANT CUSTOMIZATION ----------------
func _on_change_pants_pressed():
	current_pant_index = (current_pant_index + 1) % pant_colors.size()
	var pant_texture_path = "kenney_modular-characters/PNG/Pants/pants" + pant_colors[current_pant_index] + "_long.png"
	pant_sprite.texture = load(pant_texture_path)
	pant2_sprite.texture = load(pant_texture_path)  # Apply to both legs

# ---------------- SHOES CUSTOMIZATION ----------------
func _on_change_shoes_pressed():
	current_shoe_index = (current_shoe_index + 1) % shoe_colors.size()
	var shoe_texture_path = "kenney_modular-characters/PNG/Shoes/" + shoe_colors[current_shoe_index] + "Shoe3.png"
	shoe1_sprite.texture = load(shoe_texture_path)
	shoe2_sprite.texture = load(shoe_texture_path)  # Update both shoes
	
# ---------------- DEFAULT BELT SETUP ----------------
func _ready():
	belt_sprite.texture = load("kenney_modular-characters/PNG/belt.png")  # Load default belt texture

# ---------------- SAVE CUSTOMIZATION ----------------
func _on_save_pressed():
	# Ensure the character has a name
	var character_name = name_input.text.strip_edges()
	if character_name == "":
		character_name = "noname"

	# Create a save directory if it doesn't exist
	var save_dir = "CustomCharacters/"

	# Define the save path using the character's name
	var save_path = save_dir + character_name + ".json"

	# Create a dictionary of character data, storing the actual texture paths used
	var save_data = {
		"name": character_name,
		"face_texture": face_sprite.texture.resource_path if face_sprite.texture else "",
		"features_texture": features_sprite.texture.resource_path if features_sprite.texture else "",
		"hair_texture": hair_sprite.texture.resource_path if hair_sprite.texture else "",
		"shirt_texture": shirt_sprite.texture.resource_path if shirt_sprite.texture else "",
		"pant2_texture": pant2_sprite.texture.resource_path if pant2_sprite.texture else "",
		"pant_texture": pant_sprite.texture.resource_path if pant_sprite.texture else "",
		"shoe1_texture": shoe1_sprite.texture.resource_path if shoe1_sprite.texture else "",
		"shoe2_texture": shoe2_sprite.texture.resource_path if shoe2_sprite.texture else "",
		"arm_texture": arm_sprite.texture.resource_path if arm_sprite.texture else "",
		"arm2_texture": arm2_sprite.texture.resource_path if arm2_sprite.texture else "",
		"hand_texture": hand_sprite.texture.resource_path if hand_sprite.texture else "",
		"hand2_texture": hand2_sprite.texture.resource_path if hand2_sprite.texture else "",
		"neck_texture": neck_sprite.texture.resource_path if neck_sprite.texture else "",
		"belt_texture": "kenney_modular-characters/PNG/belt.png"  # Belt always has the default texture
	}

	# Save the data as JSON
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data, "\t"))  # Pretty print JSON
	file.close()

	print("Character saved at:", save_path)
	


# ---------------- LOAD CUSTOMIZATION ----------------
func load_character(character_name):
	var save_path = "CustomCharacters/" + character_name + ".json"

	# Check if the character save file exists
	if not FileAccess.file_exists(save_path):
		print("Error: No saved character found for", character_name)
		return

	# Load the JSON data
	var file = FileAccess.open(save_path, FileAccess.READ)
	var save_data = JSON.parse_string(file.get_as_text())
	file.close()

	# Apply the loaded customization by assigning textures
	name_input.text = save_data["name"]
	face_sprite.texture = load(save_data["face_texture"]) if save_data["face_texture"] != "" else null
	features_sprite.texture = load(save_data["features_texture"]) if save_data["features_texture"] != "" else null
	hair_sprite.texture = load(save_data["hair_texture"]) if save_data["hair_texture"] != "" else null
	shirt_sprite.texture = load(save_data["shirt_texture"]) if save_data["shirt_texture"] != "" else null
	pant_sprite.texture = load(save_data["pant_texture"]) if save_data["pant_texture"] != "" else null
	pant2_sprite.texture = load(save_data["pant2_texture"]) if save_data["pant2_texture"] != "" else null
	shoe1_sprite.texture = load(save_data["shoe1_texture"]) if save_data["shoe1_texture"] != "" else null
	shoe2_sprite.texture = load(save_data["shoe2_texture"]) if save_data["shoe2_texture"] != "" else null
	arm_sprite.texture = load(save_data["arm_texture"]) if save_data["arm_texture"] != "" else null
	arm2_sprite.texture = load(save_data["arm2_texture"]) if save_data["arm2_texture"] != "" else null
	hand_sprite.texture = load(save_data["hand_texture"]) if save_data["hand_texture"] != "" else null
	hand2_sprite.texture = load(save_data["hand2_texture"]) if save_data["hand2_texture"] != "" else null
	neck_sprite.texture = load(save_data["neck_texture"]) if save_data["neck_texture"] != "" else null
	belt_sprite.texture = load(save_data["belt_texture"]) 

	print("Character loaded:", character_name)
