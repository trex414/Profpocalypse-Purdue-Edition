extends Control

@export var course_list: Array = [
	{"semester": "Freshman Fall", "inprogress": true, "courses": [
	  {"name": "CS 180", "professor": "Prof. Doomsmore", "location": "CL 1950", "time": "10 AM", "description": "Learn suffering", "completed": false}
	]},
	{"semester": "Freshman Spring", "inprogress": false, "courses": [
	  {"name": "CS 240", "professor": "Prof. Evil", "location": "UC", "time": "1 PM", "description": "Survive pop quizzes", "completed": false},
	  {"name": "CS 182", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false} 
	]},
	{"semester": "Sophmore Fall", "inprogress": false, "courses": [
	  {"name": "CS 250", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false},
	  {"name": "CS 251", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false}
	]},
	{"semester": "Sophmore Spring", "inprogress": false, "courses": [
	 {"name": "CS 252", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false}
	]},
	{"semester": "Junior Fall", "inprogress": false, "courses": [
	 {"name": "CS 354", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false}
	]},
	{"semester": "Junior Spring", "inprogress": false, "courses": [
	 {"name": "CS 307", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false}
	]},
	{"semester": "Senior Fall", "inprogress": false, "courses": [
	 {"name": "CS 381", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false}
	]},
	{"semester": "Senior Spring", "inprogress": false, "courses": [
	{"name": "CS 408", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false},
	{"name": "CS 407", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false}
	]}
]

var current_semester: String = "Freshman Fall"  # Change this to switch displayed semester
var semester_index: int = 0  # Tracks which semester we're on

@onready var flowchart = $CanvasLayer/Panel/PrerequisiteFlowchartTexture
@onready var grid_container = $CanvasLayer/Panel/TabContainer/CurrentSemester
@onready var CompleteSemester = $CanvasLayer/Panel/CompleteSemester
@onready var NewSemester = $CanvasLayer/Panel/NewSemester
@onready var progress_bar = $CanvasLayer/Panel/ProgressBar
@onready var PrerequisiteFlowchartButton = $CanvasLayer/Panel/PrerequisiteFlowchart

func _ready():
	semester_index = PlayerData.semester_index
	current_semester = PlayerData.current_semester
	update_display()
	CompleteSemester.pressed.connect(_on_complete_semester_pressed)
	NewSemester.pressed.connect(_on_new_semester_pressed)
	progress_bar.value = semester_index
	flowchart.visible = false
	PrerequisiteFlowchartButton.pressed.connect(toggle_flowchart)
	toggle_MajorInfo()

func update_display():
	# Clear previous labels
	clear_current_semester()

	# Find the selected semester
	for semester in course_list:
		if semester["semester"] == current_semester:
			var courses = semester["courses"]
			for course in courses:
				var vbox = VBoxContainer.new()  # Create a column for each course
				
				# Add labels for each course field
				for field in ["name", "professor", "location", "time", "description"]:
					var label = Label.new()
					label.autowrap_mode = TextServer.AUTOWRAP_WORD  # Enables word wrapping
					label.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Allows resizing to fit container
					label.custom_minimum_size.x = 150  # Set a fixed width (adjust as needed)
					label.text = field.capitalize() + ": " + course[field]
					vbox.add_child(label)

					grid_container.add_child(vbox)  # Add the column to the gri
			break  # Stop searching once we find the semester

func set_semester(semester_name: String):
	current_semester = semester_name
	update_display()  # Refresh the UI
	
func clear_current_semester():
	for child in grid_container.get_children():
		child.queue_free()

func toggle_MajorInfo():
	var panel = $CanvasLayer/Panel
	panel.visible = !panel.visible

	# Update inventory UI when opening
	if panel.visible:
		update_display()
		print("Major Info opened.")
	else:
		flowchart.visible = false
		print("Major Info closed.")
		


# this one is the entire process of completing a semester and gaining a new one
# the next two are split up for the purpose of the requirements I set during planning
func complete_current_semester():
	var next_semester = get_next_semester()
	PlayerData.current_semester = next_semester
	if next_semester:
		current_semester = next_semester
		semester_index += 1  # Increment semester index
		progress_bar.value = semester_index  # Update progress bar
		
		PlayerData.semester_index = semester_index
		
		update_display()
	else:
		print("No more semesters!")  # Debug message
		clear_current_semester()
		progress_bar.value = 8  # Update progress bar

func _on_complete_semester_pressed():
	if semester_index < 8:
		var next_semester = get_next_semester()
		PlayerData.current_semester = next_semester
		current_semester = next_semester
		semester_index += 1  # Increment semester index
		PlayerData.semester_index = semester_index
		progress_bar.value = semester_index  # Update progress bar
		clear_current_semester()


		
func _on_new_semester_pressed():
	if semester_index < 8:
		update_display()
	else:
		print("No more semesters!")  # Debug message


func get_next_semester() -> String:
	if semester_index + 1 < course_list.size():
		return course_list[semester_index + 1]["semester"]
	return ""  # No more semesters

func toggle_flowchart():
	flowchart.visible = !flowchart.visible  # Toggle visibility
