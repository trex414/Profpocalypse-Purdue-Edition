extends Control

@export var course_list: Array = [
	{"semester": "Freshman Fall", "inprogress": true, "courses": [
	  {"name": "CS 180", "professor": "Prof. Doomsmore", "location": "CL 1950", "time": "10 AM", "description": "Learn suffering", "completed": false, "prerequisites": "None"}
	]},
	{"semester": "Freshman Spring", "inprogress": false, "courses": [
	  {"name": "CS 240", "professor": "Prof. Evil", "location": "UC", "time": "1 PM", "description": "Survive pop quizzes", "completed": false, "prerequisites": "CS180"},
	  {"name": "CS 182", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false, "prerequisites": "CS180"} 
	]},
	{"semester": "Sophmore Fall", "inprogress": false, "courses": [
	  {"name": "CS 250", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false, "prerequisites": "CS240"},
	  {"name": "CS 251", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false, "prerequisites": "CS182"}
	]},
	{"semester": "Sophmore Spring", "inprogress": false, "courses": [
	 {"name": "CS 252", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false, "prerequisites": "CS251"}
	]},
	{"semester": "Junior Fall", "inprogress": false, "courses": [
	 {"name": "CS 354", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false, "prerequisites": "None"}
	]},
	{"semester": "Junior Spring", "inprogress": false, "courses": [
	 {"name": "CS 307", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false, "prerequisites": "None"}
	]},
	{"semester": "Senior Fall", "inprogress": false, "courses": [
	 {"name": "CS 381", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false, "prerequisites": "None"}
	]},
	{"semester": "Senior Spring", "inprogress": false, "courses": [
	{"name": "CS 408", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false, "prerequisites": "None"},
	{"name": "CS 407", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false, "prerequisites": "None"}
	]}
]

var current_semester: String = "Freshman Fall"  # Change this to switch displayed semester
var semester_index: int = 0  # Tracks which semester we're on
var last_pressed = 0

@onready var flowchart = $CanvasLayer/Panel/PrerequisiteFlowchartTexture
@onready var grid_container = $CanvasLayer/Panel/TabContainer/CurrentSemester
@onready var CompleteSemester = $CanvasLayer/Panel/CompleteSemester
@onready var NewSemester = $CanvasLayer/Panel/NewSemester
@onready var progress_bar = $CanvasLayer/Panel/ProgressBar
@onready var PrerequisiteFlowchartButton = $CanvasLayer/Panel/PrerequisiteFlowchart
@onready var vbox = $CanvasLayer/Panel/TabContainer/PlanOfStudy/VboxPlanOfStudy
@onready var popup = $CanvasLayer/Panel/PopupPanel  # Reference to the PopupPanel
@onready var popup_vbox = popup.get_node("VBoxContainer")  # Get the VBox inside the popup


func _ready():
	semester_index = PlayerData.semester_index
	current_semester = PlayerData.current_semester
	update_display()
	CompleteSemester.pressed.connect(_on_complete_semester_pressed)
	NewSemester.pressed.connect(_on_new_semester_pressed)
	progress_bar.value = semester_index
	flowchart.visible = false
	PrerequisiteFlowchartButton.pressed.connect(toggle_flowchart)
	fill_vbox()
	toggle_MajorInfo()

func update_display():
	# Clear previous labels
	clear_current_semester()
	fill_vbox()
	# Find the selected semester
	for semester in course_list:
		if semester["semester"] == current_semester:
			var courses = semester["courses"]
			for course in courses:
				var vbox = VBoxContainer.new()  # Create a column for each course
				# Add labels for each course field
				for field in ["name", "professor", "location", "time", "description", "prerequisites"]:
					var label = Label.new()
					label.autowrap_mode = TextServer.AUTOWRAP_WORD  # Enables word wrapping
					label.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Allows resizing to fit container
					label.custom_minimum_size.x = 150  # Set a fixed width (adjust as needed)
					label.text = field.capitalize() + ": " + course[field]
					vbox.add_child(label)
					grid_container.add_child(vbox)  # Add the column to the gri
			break  # Stop searching once we find the semester

func clear_current_semester():
	for child in grid_container.get_children():
		child.queue_free()

func fill_vbox():
	for child in vbox.get_children():
		child.queue_free()
	for i in range(course_list.size()):
		var semester_data = course_list[i]
		# Create a Label for the semester
		var semester_label = Label.new()
		semester_label.text = semester_data["semester"]
		# Color the label based on its status
		if i < semester_index:
			semester_label.add_theme_color_override("font_color", Color(0, 1, 0))  # Green (Completed)
		elif i == semester_index:
			semester_label.add_theme_color_override("font_color", Color(1, 1, 0))  # Yellow (In Progress)
		else:
			semester_label.add_theme_color_override("font_color", Color(1, 0, 0))  # Red (Upcoming)
		vbox.add_child(semester_label)
		# Loop through courses and add buttons
		for course in semester_data["courses"]:
			var course_button = Button.new()
			course_button.text = course["name"]
			course_button.pressed.connect(_on_course_button_pressed.bind(course))
			vbox.add_child(course_button)

func set_semester(semester_name: String):
	current_semester = semester_name
	update_display()  # Refresh the UI

func get_next_semester() -> String:
	if semester_index + 1 < course_list.size():
		return course_list[semester_index + 1]["semester"]
	return ""  # No more semesters

func toggle_MajorInfo():
	var panel = $CanvasLayer/Panel
	panel.visible = !panel.visible
	# Update inventory UI when opening
	if panel.visible:
		update_display()
		print("Major Info opened.")
	else:
		flowchart.visible = false
		popup.visible = false
		print("Major Info closed.")

func toggle_flowchart():
	flowchart.visible = !flowchart.visible  # Toggle visibility

func toggle_popup():
	popup.visible = !popup.visible  # Toggle visibility

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
		fill_vbox()
		progress_bar.value = 8  # Update progress bar

func _on_complete_semester_pressed():
	if last_pressed == 0:
		if semester_index < 8:
			var next_semester = get_next_semester()
			PlayerData.current_semester = next_semester
			current_semester = next_semester
			semester_index += 1  # Increment semester index
			PlayerData.semester_index = semester_index
			progress_bar.value = semester_index  # Update progress bar
			clear_current_semester()
			last_pressed = 1
		fill_vbox()

func _on_new_semester_pressed():
	if last_pressed == 1:
		if semester_index < 8:
			update_display()
		else:
			print("No more semesters!")  # Debug message
			
		last_pressed = 0
		
func _on_course_button_pressed(course):
	# Clear previous popup content
	for child in popup_vbox.get_children():
		child.queue_free()
	# Add new labels dynamically
	var title_label = Label.new()
	title_label.text = "Course: " + course["name"]
	popup_vbox.add_child(title_label)
	var professor_label = Label.new()
	professor_label.text = "Professor: " + course["professor"]
	popup_vbox.add_child(professor_label)
	var location_label = Label.new()
	location_label.text = "Location: " + course["location"]
	popup_vbox.add_child(location_label)
	var time_label = Label.new()
	time_label.text = "Time: " + course["time"]
	popup_vbox.add_child(time_label)
	var description_label = Label.new()
	description_label.text = "Description: " + course["description"]
	popup_vbox.add_child(description_label)
	var prereq_label = Label.new()
	prereq_label.text = "Prerequisites: " + course["prerequisites"]
	popup_vbox.add_child(prereq_label)
	# Add Close Button
	var close_button = Button.new()
	close_button.text = "Close"
	close_button.pressed.connect(_on_close_button_pressed)
	popup_vbox.add_child(close_button)
	# Show the popup
	popup.show()

func _on_close_button_pressed():
	popup.hide()  # Hide popup
