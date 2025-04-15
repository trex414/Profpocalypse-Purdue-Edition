# health_bar.gd
# This script manages the heale system for the player
# This includes gaining health, losing health, changing the color, and print if dead
extends Control

# Create variables needed for the health barwwwwwwwwww
var current_health: int
var max_health: int

# Call the required scene items
@onready var health_bar = $Health 
@onready var stylebox = health_bar.get("theme_override_styles/fill")
@onready var lose_health_button = $Lose_Health
@onready var health_label = $health

# initilize the Health bar as well as ignoring mouse so we can interact with other layers
func _ready():
	current_health = PlayerData.health
	max_health = PlayerData.max_health  # Load saved max health
	health_bar.value = current_health
	update_health_color()
	lose_health_button.connect("pressed", Callable(self, "on_lose_health_pressed"))
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	update_health_bar()
	
# Function to test attack with button
func on_lose_health_pressed():
	lose_health(10)

# Function to decrease health
func lose_health(amount: int):
	$HealthLossSFX.play()
	if current_health <= 0:
		#DEBUG
		print("You died and cannot lose more.")
		return
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		#DEBUG
		print("You died and cannot lose more.")
	update_health_bar()
	
	# Update PlayerData
	PlayerData.health = current_health

# Function to increase health
func add_health(amount: int):
	$HealthGainSFX.play()
	if current_health >= max_health:
		#DEBUG
		print("Health full and will not add more.")
		return
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	update_health_bar()
	
	# Update PlayerData
	PlayerData.health = current_health

# Function to update the health bar UI
func update_health_bar():
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_label.text = "%d / %d" % [current_health, max_health]
	update_health_color()

# Function to change the health bar color based on health level
func update_health_color():
	var new_stylebox = StyleBoxFlat.new()
	if current_health > 50:
		new_stylebox.bg_color = Color(0.1, 0.7, 0.1)  # Green
	elif current_health > 20:
		new_stylebox.bg_color = Color(0.7, 0.7, 0.1)  # Yellow
	else:
		new_stylebox.bg_color = Color(0.7, 0.1, 0.1)  # Red
	health_bar.add_theme_stylebox_override("fill", new_stylebox)
	
# Function to increase max health
func increase_max_health(amount: int):
	# Increase max health
	max_health += amount
	current_health += amount
	PlayerData.max_health = max_health
	PlayerData.health = current_health
	update_health_bar()  # Refresh UI
	
