extends Control

@export var max_health: int = 100
var current_health: int = max_health

@onready var health_bar = $Health
@onready var stylebox = health_bar.get("theme_override_styles/fill")

func initialize(enemy_data: Dictionary):
	if "max_health" in enemy_data:
		max_health = enemy_data["max_health"]
		current_health = max_health  # Set current health to max initially
	update_health_bar()

func _ready():
	current_health = max_health
	update_health_bar()

func take_damage(amount: int):
	if current_health <= 0:
		print("Enemy already defeated.")
		return
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		print("Enemy defeated")
	update_health_bar()

func heal(amount: int):
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	update_health_bar()

func update_health_bar():
	health_bar.value = current_health
	update_health_color()

func update_health_color():
	var new_stylebox = StyleBoxFlat.new()

	if current_health > 50:
		new_stylebox.bg_color = Color(0.1, 0.7, 0.1)  # Green
	elif current_health > 20:
		new_stylebox.bg_color = Color(0.7, 0.7, 0.1)  # Yellow
	else:
		new_stylebox.bg_color = Color(0.7, 0.1, 0.1)  # Red

	health_bar.add_theme_stylebox_override("fill", new_stylebox)

func reset_health():
	current_health = max_health
	update_health_bar()
