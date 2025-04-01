extends Control

var trivia_pages = [
	{"text": "???", "unlocked": false},  # Page 1
	{"text": "???", "unlocked": false},  # Page 2
	{"text": "???", "unlocked": false},  # Page 3
]

var real_trivia = [
	"4 Purdue Petes are selected every year.",
	"Purdue adopted black and gold as its official colors in 1887.",
	"Purdue Pete originally began as the mascot for the University Bookstore."
]

var current_page = 1;

func _input(event):
	if event.is_action_pressed("trivia_book"):  # When "Z" is pressed
		toggle_book()

func toggle_book():
	var panel = $CanvasLayer/Panel
	panel.visible = !panel.visible

func update_pages():
	var page_data = trivia_pages[current_page - 1]
	var which_page = current_page % 2
	var label_path
	
	if which_page == 1:
		label_path = $HBoxContainer/RichTextLabel
	else:
		label_path = $HBoxContainer/RichTextLabel2
	
	if (page_data["unlocked"]):
		label_path.text = page_data["text"]
	else:
		label_path.text = "???"
		
	$Previous.disabled = current_page == 1
	$Next.disabled = current_page == trivia_pages.size() - 1
	
func next_page():
	if current_page < trivia_pages.size() - 1:
		current_page += 2
		update_pages()
		print("Player clicked NEXT, now on page:", current_page)

func prev_page():
	if current_page > 1:
		current_page -= 2
		update_pages()
		print("Player clicked PREVIOUS, now on page:", current_page)
