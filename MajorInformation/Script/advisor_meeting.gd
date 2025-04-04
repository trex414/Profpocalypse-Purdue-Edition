extends Node

@onready var panel = $CanvasLayer/Panel
@onready var text_box = $CanvasLayer/Panel/Label
@onready var yes_button = $CanvasLayer/Panel/yesbutton
@onready var no_button = $CanvasLayer/Panel/nobutton
@onready var okay_button = $CanvasLayer/Panel/okbutton

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

var dialogue_queue = []
var in_dialogue = false
var current_semester = 0
var majorInformation = null

func _ready():
	panel.visible = false  # Start hidden
	yes_button.pressed.connect(_on_yesbutton_pressed)
	no_button.pressed.connect(_on_nobutton_pressed)
	okay_button.pressed.connect(_on_okbutton_pressed)

func toggle_advisor_visibility():
	print("entering advisor meeting")
	panel.visible = !panel.visible
	if panel.visible:
		start_dialogue()

func start_dialogue():
	majorInformation.toggle_MajorInfo()
	text_box.text = ""
	yes_button.hide()
	no_button.hide()
	okay_button.hide()
	dialogue_queue.clear()

	current_semester = PlayerData.semester_index
	# Show greeting and semester info
	dialogue_queue.append("Welcome to your academic advising session!")
	if current_semester > 0:
		dialogue_queue.append("Congratulations on completing the %s!" % course_list[current_semester - 1]["semester"])
	dialogue_queue.append("Here are your courses for the %s:" % course_list[current_semester]["semester"])
	
	for course in course_list[current_semester]["courses"]:
		dialogue_queue.append("- %s: %s" % [course["name"], course["description"]])

	dialogue_queue.append("Would you like to start the next semester?")
	in_dialogue = true
	show_next_dialogue()

func show_next_dialogue():
	if dialogue_queue:
		text_box.text = dialogue_queue.pop_front()
		get_tree().create_timer(2.0).timeout.connect(show_next_dialogue)  # Waits 2 seconds before showing the next line
	else:
		okay_button.hide()
		yes_button.show()
		no_button.show()
		in_dialogue = false

func _on_yesbutton_pressed():
	text_box.text = "Great! Starting Semester %d..." % (current_semester + 1)
	current_semester += 1  # Progress to next semester
	#PlayerData.semester_index = current_semester
	majorInformation.complete_current_semester()
	yes_button.hide()
	no_button.hide()
	okay_button.show()


func _on_nobutton_pressed():
	text_box.text = "Ok comeback when you're ready!"
	yes_button.hide()
	no_button.hide()
	okay_button.show()
	#majorInformation.toggle_MajorInfo()

	

func _on_okbutton_pressed():
	dialogue_queue = ["Goodluck!"]
	in_dialogue = true
	show_next_dialogue()
	in_dialogue = false
	toggle_advisor_visibility()
	#majorInformation.toggle_MajorInfo()

func set_majorInfo(givenMajorInfo):
	majorInformation = givenMajorInfo
