extends Node2D


func _ready():
	#name = "Clickable_" + str(randi())  # Or set it in the scene editor
	var area = $Area2D
	area.input_event.connect(_on_area_input)

func _on_area_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("You clicked on:", self.name)
		match self.name:
			"Person1":
				print("clicked on Person1")
			"Person2":
				print("clicked on Person2")
			"Person3":
				print("clicked on Person3")
			"Person4":
				print("clicked on Person4")
			"Person5":
				print("clicked on Person5")
			"Person6":
				print("clicked on Person6")
			"Person7":
				print("clicked on Person7")
			"Person8":
				print("clicked on Person8")
			"Person9":
				print("clicked on Person9")
			"Person10":
				print("clicked on Person10")
			"Person11":
				print("clicked on Person11")
			"Person12":
				print("clicked on Person12")
			"Person13":
				print("clicked on Person13")
			"Person14":
				print("clicked on Person14")
			"Person15":
				print("clicked on Person15")
			"Person16":
				print("clicked on Person16")
