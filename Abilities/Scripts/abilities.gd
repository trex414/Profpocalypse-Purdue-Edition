extends Control

var abilities = {
	"GPA": { "description": "Max health", "base_value": 10, "current_value": 0 },
	"Brownie Points": { "description": "Subtracted from damage", "base_value": 10, "current_value": 0 },
	"Luck": { "description": "Subtracted from hit chance", "base_value": 10, "current_value": 0 },
	"Extra Credit": { "description": "HP that renews each round/combat (item-based)", "base_value": 10, "current_value": 0 },
	"Brilliant Answer %": { "description": "% chance to deal 2x or 1.5x damage", "base_value": 10, "current_value": 0 },
	"Move Speed": { "description": "Affects player movement", "base_value": 10, "current_value": 0 },
	"Hint Odds": { "description": "Chance to receive a cryptic hint", "base_value": 10, "current_value": 0 },
	"Intelligence": { "description": "Reduce number of multiple choices for trivia questions", "base_value": 10, "current_value": 0 }
}

@onready var ability_buttons = {
	"GPA": $CanvasLayer2/Panel/ScrollContainer/VBoxContainer/GPAFlowContainer/Button,
	"Brownie Points": $CanvasLayer2/Panel/ScrollContainer/VBoxContainer/BrowniePointsFlowContainer/Button,
	"Luck": $CanvasLayer2/Panel/ScrollContainer/VBoxContainer/LuckFlowContainer/Button,
	"Extra Credit": $CanvasLayer2/Panel/ScrollContainer/VBoxContainer/ExtraCreditFlowContainer/Button,
	"Brilliant Answer %": $CanvasLayer2/Panel/ScrollContainer/VBoxContainer/BrilliantAnswerChanceFlowContainer/Button,
	"Move Speed": $CanvasLayer2/Panel/ScrollContainer/VBoxContainer/MoveSpeedFlowContainer/Button,
	"Hint Odds": $CanvasLayer2/Panel/ScrollContainer/VBoxContainer/HintOddsFlowContainer/Button,
	"Intelligence": $CanvasLayer2/Panel/ScrollContainer/VBoxContainer/IntelligenceFlowContainer/Button
}

@onready var tokens_label = $CanvasLayer2/Panel/tokenslabel
@onready var tokens_button = $CanvasLayer2/Panel/tokensbutton

@onready var labels_container = $CanvasLayer/VBoxContainer  
@onready var progress_container = $CanvasLayer/VBoxContainer2  
@onready var open_detailed_view = $CanvasLayer/VBoxContainer/Button
@onready var details_panel = $CanvasLayer2

@onready var health_bar_script = get_node("res://Main HUD/Script/health_bar.gd")  # Adjust path!

var health_bar: Control  # Declare health bar variable

var health_per_GPA = 10  # Increase max health by 2 per GPA point
var study_tokens = 30  # Global variable for Study Tokens

func _ready():
	open_detailed_view.pressed.connect(_on_open_abilities_button_pressed)
	tokens_button.pressed.connect(_on_tokens_button_pressed)
	for ability_name in ability_buttons.keys():
		var button = ability_buttons[ability_name]
		button.pressed.connect(func(): _on_ability_button_pressed(ability_name))
	update_ui()

# This function can be called when you want to increase the max health
func set_health_bar(health_bar_ref: Control):
	health_bar = health_bar_ref  # Assign the health bar reference

# Updates all UI elements (labels, progress bars, and buttons)
func update_ui():
	for ability in abilities.keys():
		var value = abilities[ability]["current_value"]
		var base_value = abilities[ability]["base_value"]

		# Update labels
		for label in labels_container.get_children():
			if label.name == ability:
				label.text = "%s: %d/%d" % [ability, value, base_value]

		# Update progress bars
		for bar in progress_container.get_children():
			if bar.name == ability and bar is ProgressBar:
				bar.value = value

		# Update buttons' visibility
		if ability in ability_buttons:
			var button = ability_buttons[ability]
			button.visible = study_tokens > 0 and value < 10  # Only show if tokens > 0 and value < 10
	
	# Update study tokens label
	update_study_tokens_label()

	# Update detailed view if visible
	if details_panel.visible:
		update_detailed_view()

# Updates the detailed ability UI
func update_detailed_view():
	for ability in abilities.keys():
		var value = abilities[ability]["current_value"]
		var progress_bar = details_panel.get_node("Panel/ScrollContainer/VBoxContainer/%sFlowContainer/ProgressBar" % ability.replace(" ", ""))
		var label = details_panel.get_node("Panel/ScrollContainer/VBoxContainer/%sFlowContainer/Label2" % ability.replace(" ", ""))
		if ability == "Brilliant Answer %":
			progress_bar = details_panel.get_node("Panel/ScrollContainer/VBoxContainer/BrilliantAnswerChanceFlowContainer/ProgressBar")
			label = details_panel.get_node("Panel/ScrollContainer/VBoxContainer/BrilliantAnswerChanceFlowContainer/Label2")
			
		var button = ability_buttons[ability]
		button.visible = study_tokens > 0 and value < 10  # Update button visibility

		if progress_bar:
			progress_bar.value = value
		if label:
			label.text = str(value) + "/" + str(abilities[ability]["base_value"])
		
		var ability_safe_name = ability.replace(" ", "")
		var description_container = details_panel.get_node("Panel/ScrollContainer/VBoxContainer/Discrip%s" % ability_safe_name)
		var flow_container = details_panel.get_node("Panel/ScrollContainer/VBoxContainer/%sFlowContainer" % ability_safe_name)
		if ability == "Brilliant Answer %":
			flow_container = details_panel.get_node("Panel/ScrollContainer/VBoxContainer/BrilliantAnswerChanceFlowContainer")
			description_container = details_panel.get_node("Panel/ScrollContainer/VBoxContainer/DiscripBrilliantAnswer")

# Set visibility based on current_value
		var is_visible = value > -1
		if flow_container:
			flow_container.visible = is_visible
		if description_container:
			description_container.visible = is_visible
	
	update_study_tokens_label()  # Update tokens label here too

# Toggles the detailed ability view
func _on_open_abilities_button_pressed():
	details_panel.visible = !details_panel.visible
	if details_panel.visible:
		update_detailed_view()

# Handles ability button press
func _on_ability_button_pressed(ability_name):
	if study_tokens > 0 and abilities[ability_name]["current_value"] < 10:
		abilities[ability_name]["current_value"] += 1
		study_tokens -= 1
		
		# If GPA is upgraded, increase max health
 		# Increase max health by 10 (or any desired value)
		if health_bar:
			health_bar.increase_max_health(health_per_GPA)  # Increase max health
		else:
			print("HealthBar node not found!")	
			
		update_ui()  # Refresh UI after change

# Handles Study Tokens button press
func _on_tokens_button_pressed():
	study_tokens += 1  # Increase Study Tokens
	update_detailed_view()  # Refresh everything including buttons

# Updates Study Tokens label
func update_study_tokens_label():
	tokens_label.text = "Study Tokens: " + str(study_tokens)
