extends Node2D

@export var trivia_index: int  # Set this in the Inspector
@onready var dialogue_box = $"../../UI/DialogueBox"
@onready var fact_label = $"../../UI/DialogueBox/Panel/VBoxContainer/FactLabel"
@onready var unlock_label = $"../../UI/DialogueBox/Panel/VBoxContainer/UnlockLabel"
@onready var close_button = $"../../UI/DialogueBox/Panel/CloseButton"

func _ready():
	# Ensure the Area2D node's input event is connected
	$Area2D.connect("input_event", Callable(self, "_on_interacted"))

func _on_interacted(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Player clicked interactable!")

		# Find the existing TriviaBook node in the current scene
		var book = get_tree().current_scene.find_child("TriviaBook", true, false)

		if book:
			var result = book.unlock_trivia(trivia_index)
			var is_new = result[0]
			var sequential_number = result[1]
			var fact_text = result[2]
			show_dialogue(fact_text, is_new, sequential_number)
		else:
			print("Error: TriviaBook node not found!")

		# Hide or remove the interactable after interaction
		visible = false  # Or use queue_free() to remove it

func show_dialogue(fact_text, is_new, sequential_number):
	#var dialogue_box = get_tree().current_scene.find_child("DialogueBox", true, false)
	if dialogue_box:
		dialogue_box.visible = true
		print("dialogue box visible")
		#var fact_label = dialogue_box.get_node_or_null("FactLabel")
		#var unlock_label = dialogue_box.get_node_or_null("UnlockLabel")
		#var close_button = dialogue_box.get_node_or_null("CloseButton")

		if fact_label:
			fact_label.text = "[center]" + fact_text
		else:
			print("Error: FactLabel node not found in DialogueBox")

		if unlock_label:
			unlock_label.text = "[center]New Trivia Unlocked! Entry #" + str(sequential_number) if is_new else "[center]Already Unlocked."
		else:
			print("Error: UnlockLabel node not found in DialogueBox")

		#if close_button:
			#close_button.connect("pressed", Callable(dialogue_box, "hide"), CONNECT_DEFERRED)
	else:
		print("Error: DialogueBox node not found in scene")
