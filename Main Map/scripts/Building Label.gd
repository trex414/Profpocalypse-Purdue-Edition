extends Area2D

@onready var label = $Label  # Assuming Label is a child of this Area2D
@onready var enterpop = $"../../UI/Control"
@onready var enterpoplabel = $"../../UI/Control/Panel/Label"
var can_trigger_enter := false

func _ready():
	label.hide()  # Hide label initially
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	await get_tree().process_frame
	can_trigger_enter = true

func _process(_delta):
	if enterpop.visible:
		label.hide()
	if label.visible:
		label.global_position = get_global_mouse_position() + Vector2(10, 10)  # Offset from cursor

func _on_mouse_entered():
	label.show()

func _on_mouse_exited():
	label.hide()
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		label.hide()
		enterpoplabel.text = ("Do you wish to enter " + str(label.get_parent().name) + "?")
		enterpop.show()
		match name:
			"PMU":  # Memorial Mall (example)
				PlayerData.visited_union = true
				QuestManager.mark_ready_to_complete("Campus Curiosity Part 1: Landmarks of Lore")
			"WALC":
				PlayerData.visited_walc = true
				QuestManager.mark_ready_to_complete("Campus Curiosity Part 2: The Library Tour")
			"DSAI":
				PlayerData.visited_hicks_notes = true 
				QuestManager.mark_ready_to_complete("Campus Curiosity Part 3: Professor’s Research")
			"HICKS":
				PlayerData.visited_hicks = true
				QuestManager.mark_ready_to_complete("Campus Curiosity Part 2: The Library Tour")
			"ARMS":
				PlayerData.visited_armstrong = true
				QuestManager.mark_ready_to_complete("Campus Curiosity Part 2: The Library Tour")
			"LILY":
				PlayerData.visited_lilly = true
				QuestManager.mark_ready_to_complete("Campus Curiosity Part 2: The Library Tour")
			"LYNN":
				PlayerData.visited_vet = true
				QuestManager.mark_ready_to_complete("Campus Curiosity Part 2: The Library Tour")
			
			"LWSN":
				PlayerData.visited_cs = true
				QuestManager.mark_ready_to_complete("Campus Curiosity Part 3: Professor’s Research")
			"PHYS":
				PlayerData.visited_physics = true
				QuestManager.mark_ready_to_complete("Campus Curiosity Part 3: Professor’s Research")
			"WTHR":
				PlayerData.visited_chemistry = true
				QuestManager.mark_ready_to_complete("Campus Curiosity Part 3: Professor’s Research")
				
		
