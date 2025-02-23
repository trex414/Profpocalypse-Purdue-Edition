extends Control

var classes = [
	{"name": "CS 180", "professor": "Prof. Doomsmore", "location": "CL 1950", "time": "10 AM", "description": "Learn suffering", "completed": false},
	{"name": "CS 240", "professor": "Prof. Evil", "location": "UC", "time": "1 PM", "description": "Survive pop quizzes", "completed": false},
	{"name": "CS 182", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false}, 
	{"name": "CS 250", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false},
	{"name": "CS 251", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false},
	{"name": "CS 252", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false},
	{"name": "CS 354", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false},
	{"name": "CS 307", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false},
	{"name": "CS 381", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false},
	{"name": "CS 408", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false},
	{"name": "CS 407", "professor": "Prof. Evil", "location": "WTHR 220", "time": "1 PM", "description": "Survive pop quizzes", "completed": false}
]
# Reference to the GridContainer (assign this in the editor or find it dynamically)
@onready var grid = $GridContainer
@onready var class_template = $GridContainer/ClassTemplate  # A pre-made template

func _ready():
	populate_classes()

func populate_classes():
	for i in range(len(classes)):
		var class_data = classes[i]
		
		# Duplicate the template for each class
		var class_entry = class_template.duplicate()
		grid.add_child(class_entry)  

		# Assign values to labels
		class_entry.get_node("Label").text = class_data["name"]
		class_entry.get_node("Professor").text = "Prof: " + class_data["professor"]
		class_entry.get_node("Location").text = "Location: " + class_data["location"]
		class_entry.get_node("Time").text = "Time: " + class_data["time"]
		class_entry.get_node("Description").text = class_data["description"]
		
		# Set progress bar value
		class_entry.get_node("ProgressBar").value = class_data["progress"]

	# Hide the original template (so it doesn’t appear)
	class_template.hide()
