extends Control

@export var base_exp: int = 5  # EXP required for the first level
@export var growth_factor: float = 1.5  # How much EXP increases per level
var current_exp: int = 0  # Current EXP
var current_level: int = 1  # Starting level

@onready var exp_bar = $EXP  # Reference to ProgressBar (Ensure it exists)
@onready var level_label = $LevelLabel  # Reference to Label showing level
@onready var stylebox = exp_bar.get("theme_override_styles/fill")

func _ready():
	update_exp_bar()  # Update UI to reflect loaded data
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	reset_exp_data()
	
func reset_exp_data():
	current_exp = 0
	current_level = 1
	update_exp_bar()
	print("EXP data reset.")

# Function to calculate EXP required for the next level
func get_exp_to_next_level(level: int) -> int:
	return int(base_exp * pow(level, growth_factor))

# Function to add EXP
func add_exp(amount: int):
	current_exp += amount
	print("Gained", amount, "EXP. Current EXP:", current_exp)

	# Check for level up
	while current_exp >= get_exp_to_next_level(current_level):
		current_exp -= get_exp_to_next_level(current_level)  # Deduct required EXP
		current_level += 1  # Increase level
		print("Leveled up! New level:", current_level)

	update_exp_bar()

# Function to lose EXP
func lose_exp(amount: int):
	current_exp -= amount
	if current_exp < 0:
		current_exp = 0  # Prevent negative EXP
	print("Lost", amount, "EXP. Current EXP:", current_exp)
	
	update_exp_bar()

# Function to update the EXP bar UI
func update_exp_bar():
	var exp_needed = get_exp_to_next_level(current_level)
	
	# Update ProgressBar values
	exp_bar.max_value = exp_needed
	exp_bar.value = current_exp

	# Display Level and EXP as a fraction
	level_label.text = "Level: " + str(current_level) + "             EXP: " + str(current_exp) + "/" + str(exp_needed)

	update_exp_color()  # Adjust color based on level

# Function to adjust EXP bar color based on level
func update_exp_color():
	var new_stylebox = StyleBoxFlat.new()  # Create a NEW instance
	new_stylebox.bg_color = Color(0, 0.5, 1)  # Set EXP bar color (Blue)

	exp_bar.add_theme_stylebox_override("fill", new_stylebox)  # Apply to EXP Bar
