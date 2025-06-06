extends Control



@onready var face_sprite = $body_root/face  
@onready var features_sprite = $body_root/face/features
@onready var hair_sprite = $body_root/face/features/hair
@onready var shirt_sprite = $body_root/shirt
@onready var pant_sprite = $body_root/pant
@onready var pant2_sprite = $body_root/pant/pant2
@onready var shoe1_sprite = $body_root/pant/pant2/shoe
@onready var shoe2_sprite = $body_root/pant/pant2/shoe2
@onready var arm_sprite = $body_root/sleeve
@onready var arm2_sprite = $body_root/sleeve/sleeve2
@onready var hand_sprite = $body_root/sleeve/sleeve2/hand
@onready var hand2_sprite = $body_root/sleeve/sleeve2/hand2
@onready var neck_sprite = $body_root/shirt/neck
@onready var belt_sprite = $body_root/pant/pant2/belt  
@onready var class_sprite = $body_root/shirt/class
@onready var class_description = $class_description
@onready var name_input = $name
@onready var save_button = $save

var current_tint_index = 0
var current_hair_color_index = 0
var current_hair_style_index = 0
var current_features_index = 0
var current_shirt_index = 0
var current_pant_index = 0
var current_shoe_index = 0
var current_class_index = 0



var hair_colors = ["Black", "Blonde", "Brown", "Red", "White"]
var shirt_colors = ["blue", "green", "grey", "navy", "pine", "red", "white", "yellow"]
var pant_colors = ["Brown", "Green", "Grey", "LightBlue", "Navy", "Pine", "Red", "Tan", "White", "Yellow"]
var shoe_colors = ["Black", "Blue", "Brown", "Grey", "Red", "Tan"]

var class_names = [
	"art", "band", "business", "coffee", "dj", "gaming", "gym", "hippie", "international", "math",
	"med", "napper", "party", "philosophy", "politics", "skateboard", "STEM", "theatre"
]

var class_descriptions = {
	"art": "The Art Student – Covered in paint, never without a sketchbook, and insists that a chair is not just a chair.",
	"band": "The Band Geek – Always talking about rehearsals, concerts, and marching season. Probably carries a baton or drumsticks around for no reason.",
	"business": "The Business Bro – Wears Patagonia vests, talks in acronyms, and calls LinkedIn a 'hustle platform.'",
	"coffee": "The Coffee Addict – Seen at the campus café more than in class. Always holding a cup, even if it’s empty.",
	"dj": "The Dorm DJ – Has the loudest speaker on the floor. Always curating a playlist no one asked for.",
	"gaming": "The Gamer – Runs on Mountain Dew and memes. Talks in Discord jargon. Might be wearing pajamas at noon.",
	"gym": "The Gym Rat – Always in athleisure, talks about macros and gains, and hits the gym before their 8am lecture.",
	"hippie": "The Nature Hippie – Eats granola, carries a reusable water bottle and utensils, and wants to save the planet yesterday.",
	"international": "The International Student – Speaks three languages fluently, teaches others slang from their home country, and FaceTimes their family at odd hours.",
	"math": "The Math Nerd – Lives in the math building, loves proofs, talks in variables, and finds derivatives for fun.",
	"med": "The Pre-Med Machine – Shadowed a surgeon at 16, already worried about residency, and always smells faintly of hand sanitizer.",
	"napper": "The Professional Napper – Can fall asleep anywhere—library chair, bench, beanbag. A true talent.",
	"party": "The Party Animal – Knows every house on frat row, has class… but hasn’t attended since syllabus week.",
	"philosophy": "The Chill Philosopher – Spends hours debating the trolley problem and questioning reality. Probably wears a beanie and drinks herbal tea.",
	"politics": "The Political Activist – Tabling every week, protesting every month, and knows way more about policy than your poli-sci professor.",
	"skateboard": "The Skateboard Dude – Glides across campus like he owns it, backpack hanging off one shoulder, always late but somehow chill about it. Probably says 'yo' a lot.",
	"STEM": "The STEM Zombie – Sleeps 3 hours a night, survives on energy drinks, and is always debugging something.",
	"theatre": "The Theater Kid – Quotes Shakespeare, bursts into song, and thinks life is a stage."
}

func _on_change_class_pressed():
	current_class_index = (current_class_index + 1) % class_names.size()
	var class_nam = class_names[current_class_index]
	var class_icon_path = "CharacterCustomization/kenney_modular-characters/PNG/" + class_nam + ".png"
	class_sprite.texture = load(class_icon_path)
	class_description.text = class_descriptions[class_nam]

func _on_change_face_pressed():
	current_tint_index = (current_tint_index + 1) % 8
	var tint_folder = "Tint " + str(current_tint_index + 1)
	var face_texture_path = "CharacterCustomization/kenney_modular-characters/PNG/Skin/" + tint_folder + "/tint" + str(current_tint_index + 1) + "_head.png"
	face_sprite.texture = load(face_texture_path)
	var skin_texture_path = "CharacterCustomization/kenney_modular-characters/PNG/Skin/" + tint_folder + "/tint" + str(current_tint_index + 1)
	arm_sprite.texture = load(skin_texture_path + "_arm.png")
	arm2_sprite.texture = load(skin_texture_path + "_arm.png")
	hand_sprite.texture = load(skin_texture_path + "_hand.png")
	hand2_sprite.texture = load(skin_texture_path + "_hand.png")
	neck_sprite.texture = load(skin_texture_path + "_neck.png")

func _on_change_features_pressed():
	current_features_index = (current_features_index + 1) % 4
	var features_texture_path = "CharacterCustomization/kenney_modular-characters/PNG/Face/face" + str(current_features_index + 1) + ".png"
	features_sprite.texture = load(features_texture_path)

func _on_change_hair_pressed():
	current_hair_style_index += 1
	if current_hair_style_index >= 3:
		current_hair_style_index = 0
		current_hair_color_index = (current_hair_color_index + 1) % hair_colors.size()
	var hair_color = hair_colors[current_hair_color_index]
	var hair_style = ["5", "7", "8"][current_hair_style_index]
	var hair_texture_path = "CharacterCustomization/kenney_modular-characters/PNG/Hair/" + hair_color + "/" + hair_color.to_lower() + "Man" + hair_style + ".png"
	hair_sprite.texture = load(hair_texture_path)

func _on_change_shirt_pressed():
	current_shirt_index = (current_shirt_index + 1) % shirt_colors.size()
	var shirt_texture_path = "CharacterCustomization/kenney_modular-characters/PNG/Shirts/" + shirt_colors[current_shirt_index] + "Shirt7.png"
	shirt_sprite.texture = load(shirt_texture_path)

func _on_change_pants_pressed():
	current_pant_index = (current_pant_index + 1) % pant_colors.size()
	var pant_texture_path = "CharacterCustomization/kenney_modular-characters/PNG/Pants/pants" + pant_colors[current_pant_index] + "_long.png"
	pant_sprite.texture = load(pant_texture_path)
	pant2_sprite.texture = load(pant_texture_path)

func _on_change_shoes_pressed():
	current_shoe_index = (current_shoe_index + 1) % shoe_colors.size()
	var shoe_texture_path = "CharacterCustomization/kenney_modular-characters/PNG/Shoes/" + shoe_colors[current_shoe_index] + "Shoe3.png"
	shoe1_sprite.texture = load(shoe_texture_path)
	shoe2_sprite.texture = load(shoe_texture_path)

func _ready():
	Global.menu_boolean = true
	var last_character_path = "CharacterCustomization/last_saved_character.json"
	if FileAccess.file_exists(last_character_path):
		var last_character_file = FileAccess.open(last_character_path, FileAccess.READ)
		if last_character_file:
			var last_character_data = JSON.parse_string(last_character_file.get_as_text())
			last_character_file.close()
			if last_character_data and last_character_data.has("name"):
				load_character(last_character_data["name"])

func _on_save_pressed():
	var character_name = name_input.text.strip_edges()
	if character_name == "":
		character_name = "noname"

	var save_path = "CharacterCustomization/CustomCharacters/" + character_name + ".json"
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
		"belt_texture": "CharacterCustomization/kenney_modular-characters/PNG/belt.png",
		"class_texture": class_sprite.texture.resource_path if class_sprite.texture else "",
		"class_description": class_description.text
	}

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data, "\t"))
	file.close()
	print("Character saved at:", save_path)


	var last_character_path = "CharacterCustomization/last_saved_character.json"
	var last_character_file = FileAccess.open(last_character_path, FileAccess.WRITE)
	last_character_file.store_string(JSON.stringify(save_data, "\t"))
	last_character_file.close()
	#load_character("cotton")
	get_tree().change_scene_to_file("res://test_main.tscn")

		

func load_character(character_name):
	print("hii")
	var save_path = "CharacterCustomization/CustomCharacters/" + character_name + ".json"
	if not FileAccess.file_exists(save_path):
		print("Error: No saved character found for", character_name)
		return
	var file = FileAccess.open(save_path, FileAccess.READ)
	var save_data = JSON.parse_string(file.get_as_text())
	file.close()
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
	class_sprite.texture = load(save_data["class_texture"]) if save_data.has("class_texture") else null
	class_description.text = save_data["class_description"] if save_data.has("class_description") else ""
