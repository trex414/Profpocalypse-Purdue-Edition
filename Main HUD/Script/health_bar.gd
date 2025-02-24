extends Control

@export var max_health: int = 100  # Maximum health
var current_health: int = max_health  # Start with full health

@onready var health_bar = $Health  # Ensure you have a ProgressBar node named "HealthBar"
@onready var stylebox = health_bar.get("theme_override_styles/fill")
@onready var lose_health_button = $Lose_Health  # Reference to Lose Health button

func _ready():
	health_bar.value = current_health  # Initialize the health bar
	update_health_color()
	lose_health_button.connect("pressed", Callable(self, "on_lose_health_pressed"))
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func on_lose_health_pressed():
	lose_health(10)

# Function to decrease health
func lose_health(amount: int):
	if current_health <= 0:
		print("You died and cannot lose more.")
		return
	
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		print("You died and cannot lose more.")
	
	update_health_bar()

# Function to increase health
func add_health(amount: int):
	if current_health >= max_health:
		print("Health full and will not add more.")
		return
	
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	
	update_health_bar()

# Function to update the health bar UI
func update_health_bar():
	health_bar.value = current_health
	update_health_color()

# Function to change the health bar color based on health level
func update_health_color():
	if stylebox:  # Ensure the stylebox exists
		if current_health > 50:
			stylebox.bg_color = Color(0, .5, 0)  # Green
		elif current_health > 20:
			stylebox.bg_color = Color(.6, .5, 0)  # Yellow
		else:
			stylebox.bg_color = Color(.5, 0, 0)  # Red
	
