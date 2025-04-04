extends Control




func toggle_calendar():
	var panel = $CanvasLayer/Panel
	panel.visible = !panel.visible
	if panel.visible:
		populate_calendar(current_month, current_year)

# Format: "YYYY-MM-DD": "Description"
var important_dates = {
	"2025-01-13": "Spring Term Begin",
	"2025-05-03": "Spring Class End",
	"2025-05-05": "Final Exams",
	"2025-05-10": "Spring Term End",
	"2025-03-17": "Spring Break",
	"2025-05-26": "Memorial Day",
	"2025-07-04": "Fourth of July",
	"2025-04-05": "Aviation Day",
	"2025-08-25": "Fall Term Begin",
	"2025-09-09": "Industrial Roundtable"
}

var current_month: int = 4
var current_year: int = 2025


func populate_calendar(month: int, year: int):
	var mylabel = $CanvasLayer/Panel/HBoxContainer/MonthLabel
	mylabel.text = get_month_name(month) + " " + str(year)
	
	var days_in_month = get_days_in_month(month, year)
	var start_day = get_weekday_of_first(month, year)

	var grid = $CanvasLayer/Panel/GridContainer
	clear_children(grid)  # clear previous calendar content

	# Add weekday headers
	var weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	for name in weekdays:
		var header = Label.new()
		header.text = name
		header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		header.add_theme_color_override("font_color", Color.LIGHT_GRAY)
		grid.add_child(header)

	# Add 6 rows × 7 columns of date slots (max 42)
	for i in range(42):
		var slot = VBoxContainer.new()
		slot.custom_minimum_size = Vector2(60, 60)  # adjust size if needed

		var label = Label.new()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		if i >= start_day and (i - start_day + 1) <= days_in_month:
			var day = i - start_day + 1
			label.text = str(day)

			var date_key = "%d-%02d-%02d" % [year, month, day]
			if important_dates.has(date_key):
				label.add_theme_color_override("font_color", Color.RED)

				var event_label = Label.new()
				event_label.text = important_dates[date_key]
				event_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				event_label.add_theme_color_override("font_color", Color.DARK_ORANGE)
				slot.add_child(event_label)

		else:
			label.text = ""  # filler/empty days

		slot.add_child(label)
		grid.add_child(slot)
		
		
func clear_children(container: Control) -> void:
	for child in container.get_children():
		child.queue_free()


func get_days_in_month(month: int, year: int) -> int:
	match month:
		1, 3, 5, 7, 8, 10, 12:
			return 31
		4, 6, 9, 11:
			return 30
		2:
			return 29 if is_leap_year(year) else 28
		_:
			return 0  
			
func is_leap_year(year: int) -> bool:
	return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)
	
func get_weekday_of_first(month: int, year: int) -> int:
	if month < 3:
		month += 12
		year -= 1

	var q = 1  
	var k = year % 100
	var j = year / 100

	var h = (q + int((13 * (month + 1)) / 5) + k + int(k / 4) + int(j / 4) + 5 * j) % 7

	var day_index = (h + 6) % 7
	return day_index
	
	
func get_month_name(month: int) -> String:
	var month_names = [
		"January", "February", "March", "April", "May", "June",
		"July", "August", "September", "October", "November", "December"
	]
	return month_names[month - 1]


func _on_LeftButton_pressed():
	if current_month > 1:
		current_month -= 1
		populate_calendar(current_month, current_year)


func _on_RightButton_pressed():
	if current_month < 12:
		current_month += 1
		populate_calendar(current_month, current_year)
