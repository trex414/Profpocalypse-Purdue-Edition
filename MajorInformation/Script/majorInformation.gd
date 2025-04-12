extends Control

var professors_data = {
	"Prof. Doomsmore": {
		"office": "LWSN 1189",
		"difficulty": 1,
		"course": "CS 180 – Object Oriented Programming"
	},
	"Prof. Turkey": {
		"office": "LWSN 2116F",
		"difficulty": 4,
		"course": "CS 240 – Programming in C"
	},
	"Prof. Sel-key": {
		"office": "LWSN 2142H",
		"difficulty": 2,
		"course": "CS 182 – Foundations of Computer Science"
	},
	"Prof. Gust-Codes": {
		"office": "LWSN 3154G",
		"difficulty": 3,
		"course": "CS 250 – Computer Architecture"
	},
	"Prof. PosadaBytes": {
		"office": "LWSN 2116G",
		"difficulty": 4,
		"course": "CS 251 – Data Structures and Algorithms"
	},
	"Prof. Gust-Stack": {
		"office": "LWSN 3154G",
		"difficulty": 3,
		"course": "CS 252 – Systems Programming"
	},
	"Prof. KernelComer": {
		"office": "LWSN 1171",
		"difficulty": 3,
		"course": "CS 354 – Operating Systems"
	},
	"Prof. CodeZhang": {
		"office": "LWSN 3154K",
		"difficulty": 4,
		"course": "CS 307 – Software Engineering I"
	},
	"Prof. AlgoKnight": {
		"office": "LWSN 1201",
		"difficulty": 3,
		"course": "CS 381 – Analysis of Algorithms"
	},
	"Prof. CapstoneCrafter": {
		"office": "LWSN 2142G",
		"difficulty": 1,
		"course": "CS 408 – Senior Project"
	},
	"Prof. BugSquasher": {
		"office": "LWSN 1183",
		"difficulty": 1,
		"course": "CS 407 – Software Testing"
	}
}


@export var course_list: Array = [
	{"semester": "Freshman Fall", "inprogress": true, "courses": [
		{"name": "CS 180", "professor": "Prof. Doomsmore", "location": "CL 1950", "location_description": "Large Lecture Hall", "time": "10 AM", "description": "Object Oriented Programming", "completed": false, "prerequisites": ["None"], "prerequisite_numbers": [0], "difficulty": 1}
	]},
	{"semester": "Freshman Spring", "inprogress": false, "courses": [
		{"name": "CS 240", "professor": "Prof. Turkey", "location": "UC", "location_description": "Large Lecture Hall", "time": "1 PM", "description": "Programming in C", "completed": false, "prerequisites": ["CS 180"], "prerequisite_numbers": [0], "difficulty": 2},
		{"name": "CS 182", "professor": "Prof. Sel-key", "location": "WTHR 220", "location_description": "Large Lecture Hall", "time": "1 PM", "description": "Foundations of Computer Science", "completed": false, "prerequisites": ["CS 180"], "prerequisite_numbers": [0], "difficulty": 2}
	]},
	{"semester": "Sophmore Fall", "inprogress": false, "courses": [
		{"name": "CS 250", "professor": "Prof. Gust-Codes", "location": "WTHR 220", "location_description": "Large Lecture Hall", "time": "1 PM", "description": "Computer Architecture", "completed": false, "prerequisites": ["CS 240"], "prerequisite_numbers": [0], "difficulty": 2},
		{"name": "CS 251", "professor": "Prof. PosadaBytes", "location": "WTHR 220", "location_description": "Large Lecture Hall", "time": "1 PM", "description": "Data Structures and Algorithms", "completed": false, "prerequisites": ["CS 182", "CS 240"], "prerequisite_numbers": [0], "difficulty": 3}
	]},
	{"semester": "Sophmore Spring", "inprogress": false, "courses": [
		{"name": "CS 252", "professor": "Prof. Gust-Stack", "location": "WTHR 220", "location_description": "Large Lecture Hall", "time": "1 PM", "description": "Systems Programming", "completed": false, "prerequisites": ["CS 251", "CS 250"], "prerequisite_numbers": [0], "difficulty": 3}
	]},
	{"semester": "Junior Fall", "inprogress": false, "courses": [
		{"name": "CS 354", "professor": "Prof. KernelComer", "location": "WTHR 220", "location_description": "Large Lecture Hall", "time": "1 PM", "description": "Operating Systems", "completed": false, "prerequisites": ["CS 252"], "prerequisite_numbers": [0], "difficulty": 3}
	]},
	{"semester": "Junior Spring", "inprogress": false, "courses": [
		{"name": "CS 307", "professor": "Prof. CodeZhang", "location": "WTHR 220", "location_description": "Large Lecture Hall", "time": "1 PM", "description": "Software Engineering I", "completed": false, "prerequisites": ["CS 251"], "prerequisite_numbers": [0], "difficulty": 2}
	]},
	{"semester": "Senior Fall", "inprogress": false, "courses": [
		{"name": "CS 381", "professor": "Prof. AlgoKnight", "location": "WTHR 220", "location_description": "Large Lecture Hall", "time": "1 PM", "description": "Analysis of Algorithms", "completed": false, "prerequisites": ["CS 251"], "prerequisite_numbers": [0], "difficulty": 10}
	]},
	{"semester": "Senior Spring", "inprogress": false, "courses": [
		{"name": "CS 408", "professor": "Prof. CapstoneCrafter", "location": "WTHR 220", "location_description": "Large Lecture Hall", "time": "1 PM", "description": "Senior Project", "completed": false, "prerequisites": ["CS 251"], "prerequisite_numbers": [0], "difficulty": 2},
		{"name": "CS 407", "professor": "Prof. BugSquasher", "location": "WTHR 220", "location_description": "Large Lecture Hall", "time": "1 PM", "description": "Software Testing", "completed": false, "prerequisites": ["CS 307"], "prerequisite_numbers": [0], "difficulty": 2}
	]}
]


var advisorMeeting = null
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
@onready var closeButton = $CanvasLayer/Panel/CloseButton


func _ready():
	
	semester_index = PlayerData.semester_index
	current_semester = PlayerData.current_semester
	update_display()
	CompleteSemester.pressed.connect(_on_complete_semester_pressed)
	NewSemester.pressed.connect(_on_new_semester_pressed)
	closeButton.pressed.connect(on_close_pressed)
	progress_bar.value = semester_index
	flowchart.visible = false
	PrerequisiteFlowchartButton.pressed.connect(toggle_flowchart)
	fill_vbox()
	toggle_MajorInfo()
	populate_professors_tab()

	

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
				for field in ["name", "professor", "location", "location_description", "time", "description"]:
					var label = Label.new()
					label.autowrap_mode = TextServer.AUTOWRAP_WORD  # Enables word wrapping
					label.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Allows resizing to fit container
					label.custom_minimum_size.x = 170  # Set a fixed width (adjust as needed)
					label.text = field.capitalize() + ": " + course[field]
					vbox.add_child(label)
					grid_container.add_child(vbox)  # Add the column to the grid
				# Handle prerequisites separately to format them properly
				var prereq_label = Label.new()
				prereq_label.text = "Prerequisites: " + ", ".join(course["prerequisites"])
				prereq_label.autowrap_mode = TextServer.AUTOWRAP_WORD
				vbox.add_child(prereq_label)
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
			course_button.text = course["name"] + ": " + course["description"]
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
	$MajorInfoSFX.play()
	
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
		
func _on_close_button_pressed():
	popup.hide()  # Hide popup

func find_course_by_name(course_name):
	# Search for the course by name in the course_list
	for semester in course_list:
		for course in semester["courses"]:
			if course["name"] == course_name:
				return course
	return null  # Return null if the course is not found

func _on_course_button_pressed(course):
	# Clear previous popup content
	for child in popup_vbox.get_children():
		child.queue_free()

	# Course title
	var title_label = Label.new()
	title_label.text = "Course: " + course["name"]
	popup_vbox.add_child(title_label)

	# Professor
	var professor_label = Label.new()
	professor_label.text = "Professor: " + course["professor"]
	popup_vbox.add_child(professor_label)

	# Location
	var location_label = Label.new()
	location_label.text = "Location: " + course["location"]
	popup_vbox.add_child(location_label)

	# Location description
	var location_description_label = Label.new()
	location_description_label.text = "Location Description: " + course["location_description"]
	location_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	location_description_label.custom_minimum_size.x = 170
	popup_vbox.add_child(location_description_label)

	# Time
	var time_label = Label.new()
	time_label.text = "Time: " + course["time"]
	popup_vbox.add_child(time_label)

	# Description
	var description_label = Label.new()
	description_label.text = "Description: " + course["description"]
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	description_label.custom_minimum_size.x = 170
	popup_vbox.add_child(description_label)

	# Difficulty (shown as stars)
	var difficulty = course.get("difficulty")
	var stars = "⭐".repeat(difficulty)
	var difficulty_label = Label.new()
	if difficulty > 5:
		difficulty_label.text= "Difficulty:RIP 💀💀"
	else: 
		difficulty_label.text = "Difficulty: " + stars
	popup_vbox.add_child(difficulty_label)

	# Prerequisites
	if course["prerequisites"][0] != "None":
		var prereq_label = Label.new()
		prereq_label.text = "Prerequisites:"
		popup_vbox.add_child(prereq_label)

		for i in range(course["prerequisites"].size()):
			var prereq_name = course["prerequisites"][i]
			var prereq_button = Button.new()
			prereq_button.text = prereq_name
			var prereq_course = find_course_by_name(prereq_name)
			if prereq_course:
				prereq_button.pressed.connect(_on_course_button_pressed.bind(prereq_course))
			popup_vbox.add_child(prereq_button)

	# Close button
	var close_button = Button.new()
	close_button.text = "Close"
	close_button.pressed.connect(_on_close_button_pressed)
	popup_vbox.add_child(close_button)

	# Show popup
	popup.show()
	
func populate_professors_tab():
	var professors_vbox = $CanvasLayer/Panel/TabContainer/Professors/VBoxProfessors

	for professor in professors_data.keys():
		var button = Button.new()
		button.text = professor
		button.focus_mode = Control.FOCUS_NONE
		button.set_meta("original_text", professor)

		button.mouse_entered.connect(func():
			var data = professors_data[professor]
			var stars = "⭐".repeat(data["difficulty"])
			button.text = "{name}\n{office}\n{stars}".format({
				"name": professor,
				"office": data["office"],
				"stars": stars
			})
		)

		button.mouse_exited.connect(func():
			button.text = button.get_meta("original_text")
		)

		professors_vbox.add_child(button)

func on_close_pressed():
	toggle_MajorInfo()

func set_advisorMeeting(givenMeeting):
	advisorMeeting = givenMeeting
