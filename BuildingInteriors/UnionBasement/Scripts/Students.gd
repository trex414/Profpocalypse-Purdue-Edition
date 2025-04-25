extends Node2D  # or Node2D, whatever your character node is

# Dialogue lines to display
var dialogue_lines = [
	"Hello there!",
	"It's a beautiful day, isn't it?",
	"Good luck on your journey!"
]
var current_line = 0

# Node references
@onready var speech_bubble = $SpeechBubble
@onready var speech_text = $SpeechText
@onready var yes_button = $yesButton

func _ready():
	# Hide everything initially
	speech_bubble.visible = false
	speech_text.visible = false
	yes_button.visible = false
	yes_button.pressed.connect(_on_yes_button_pressed)
	var area = $Area2D
	area.input_event.connect(_on_area_input)

func _on_area_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		show_dialogue()


func show_dialogue():
	print("dialogue toggled")
	current_line = 0
	speech_bubble.visible = true
	speech_text.visible = true
	yes_button.visible = true
	update_dialogue()

func update_dialogue():
	if current_line < dialogue_lines.size():
		print("text updated")
		speech_text.text = dialogue_lines[current_line]
	else:
		hide_dialogue()

func _on_yes_button_pressed():
	current_line += 1
	update_dialogue()

func hide_dialogue():
	speech_bubble.visible = false
	speech_text.visible = false
	yes_button.visible = false
