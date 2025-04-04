# exp_bar.gd
# This script manages the experience system for the player
# This includes gaining EXP, losing EXP, leveling up
extends Control

# Build the leveling variable to make it more difficult each level
@export var base_exp: int = 5  
@export var growth_factor: float = 1.5  
var current_exp: int = 0  
var current_level: int = 1

# Call the required scene items
@onready var exp_bar = $EXP
@onready var level_label = $LevelLabel
@onready var stylebox = exp_bar.get("theme_override_styles/fill")

# initilize the EXP bar as well as ignoring mouse so we can interact with other layers
func _ready():
	current_level = PlayerData.level
	current_exp = PlayerData.exp
	update_exp_bar()
	#reset_exp_data()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
# Function to bring the EXP bar back to the start of level 1
func reset_exp_data():
	current_exp = 0
	current_level = 1
	PlayerData.exp = current_exp
	PlayerData.level = current_level
	update_exp_bar()
	# DEBUG
	print("EXP data reset.")

# Function to calculate EXP required for the next level
func get_exp_to_next_level(level: int) -> int:
	return int(base_exp * pow(level, growth_factor))

# Function to add EXP
func add_exp(amount: int):
	$EXPGainSFX.play()
	current_exp += amount
	print("Gained", amount, "EXP. Current EXP:", current_exp)

	# Check for level up
	while current_exp >= get_exp_to_next_level(current_level):
		current_exp -= get_exp_to_next_level(current_level)  
		current_level += 1
		Global.abilitiesMenu.levelup_abilities_update()
		#DEBUG
		print("Leveled up! New level:", current_level)
		
	# Update PlayerData
	PlayerData.exp = current_exp
	PlayerData.level = current_level
	
	update_exp_bar()

# Function to lose EXP
func lose_exp(amount: int):
	$EXPLossSFX.play()
	current_exp -= amount
	if current_exp < 0:
		current_exp = 0
	#DEBUG
	print("Lost", amount, "EXP. Current EXP:", current_exp)
	
	# Update PlayerData
	PlayerData.exp = current_exp
	
	update_exp_bar()


# Function to update the EXP bar UI
func update_exp_bar():
	var exp_needed = get_exp_to_next_level(current_level)
	
	# Update ProgressBar values
	exp_bar.max_value = exp_needed
	exp_bar.value = current_exp

	# Display Level and EXP as a fraction
	level_label.text = "Level: " + str(current_level) + "             EXP: " + str(current_exp) + "/" + str(exp_needed)

	update_exp_color() 

# Function to adjust EXP bar color based on level
func update_exp_color():
	var new_stylebox = StyleBoxFlat.new()  
	new_stylebox.bg_color = Color(0, 0.5, 1)  
	exp_bar.add_theme_stylebox_override("fill", new_stylebox)  
