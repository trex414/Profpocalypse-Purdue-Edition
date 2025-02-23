extends Control

var classes = [
	{"name": "CS 180", "professor": "Dr. Evil", "location": "CL1950", "time": "10 AM", "description": "Learn suffering", "progress": 50},
	{"name": "CS 240", "professor": "Ms. Doom", "location": "Room 102", "time": "1 PM", "description": "Survive pop quizzes", "progress": 75},
	{"name": "CS 182", "professor": "Ms. Doom", "location": "Room 102", "time": "1 PM", "description": "Survive pop quizzes", "progress": 75}
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
