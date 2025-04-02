extends Control

const TRIVIA_PER_PAGE = 4

var trivia_pages = []  # Stores all pages with 4 slots each

@onready var page_num_left = $CanvasLayer/Panel/PageNumLeft
@onready var page_num_right = $CanvasLayer/Panel/PageNumRight
@onready var counter = $CanvasLayer/Panel/Counter

var real_trivia = [
	"Purdue University was established in 1869, named after John Purdue.",
	"4 Purdue Petes are selected every year.",
	"Purdue adopted black and gold as its official colors in 1887.",
	"Purdue Pete originally began as the mascot for the University Bookstore.",
	"Purdue's first football game was in 1887.",
	"Neil Armstrong graduated from Purdue in 1955.",
	"The Boilermaker Special is Purdue's official mascot.",
	"Purdue has had a student-run newspaper since 1889.",
	"Boilermakers was first used as a nickname in 1891.",
	"check if next works properly"
]

var current_page = 0

func _ready():
	var panel = $CanvasLayer/Panel
	panel.visible = false
	var total_spreads = ceil(real_trivia.size() / float(TRIVIA_PER_PAGE * 2))
	for _i in range(total_spreads):
		var page = {
			"texts_left": ["???", "???", "???", "???"], 
			"texts_right": ["???", "???", "???", "???"], 
			"unlocked_left": [false, false, false, false], 
			"unlocked_right": [false, false, false, false]
		}
		trivia_pages.append(page)
	update_pages()

func _input(event):
	if event.is_action_pressed("trivia_book"):
		toggle_book()

func toggle_book():
	$TriviaBookSFX.play()
	var panel = $CanvasLayer/Panel
	panel.visible = !panel.visible
	update_pages()

func update_pages():
	var page_data = trivia_pages[current_page]

	var label_left = $CanvasLayer/Panel/HBoxContainer/RichTextLabel
	var label_right = $CanvasLayer/Panel/HBoxContainer/RichTextLabel2

	var trivia_start_index = current_page * TRIVIA_PER_PAGE * 2  # Offset in trivia array
	var displayed_text_left = ""
	var displayed_text_right = ""

	# Fill left page
	for i in range(TRIVIA_PER_PAGE):
		var global_index = trivia_start_index + i
		if global_index < real_trivia.size():
			if page_data["unlocked_left"][i]:
				displayed_text_left += str(global_index + 1) + ". " + real_trivia[global_index] + "\n\n"
			else:
				displayed_text_left += str(global_index + 1) + ". ???\n\n"

	# Fill right page
	for i in range(TRIVIA_PER_PAGE):
		var global_index = trivia_start_index + TRIVIA_PER_PAGE + i
		if global_index < real_trivia.size():
			if page_data["unlocked_right"][i]:
				displayed_text_right += str(global_index + 1) + ". " + real_trivia[global_index] + "\n\n"
			else:
				displayed_text_right += str(global_index + 1) + ". ???\n\n"

	label_left.text = displayed_text_left
	label_right.text = displayed_text_right
	
	var left_page_number = (current_page * 2) + 1  # First page should be 1
	var right_page_number = left_page_number + 1

	page_num_left.text = str(left_page_number)
	page_num_right.text = str(right_page_number)
	
	var unlocked_count = get_unlocked_trivia_count()
	counter.text = "Unlocked: " + str(unlocked_count) + " / " + str(real_trivia.size())
		
	#$Previous.disabled = current_page == 1
	#$Next.disabled = current_page == trivia_pages.size() - 1

func get_unlocked_trivia_count():
	var count = 0
	for page in trivia_pages:
		count += page["unlocked_left"].count(true)
		count += page["unlocked_right"].count(true)
	return count

func next_page():
	if current_page < trivia_pages.size() - 1:
		current_page += 1
		update_pages()
		print("Player clicked NEXT, now on page:", current_page)

func prev_page():
	if current_page > 0:
		current_page -= 1
		update_pages()
		print("Player clicked PREVIOUS, now on page:", current_page)
		
func unlock_trivia(index):
	var spread = index / (TRIVIA_PER_PAGE * 2)  # Determine spread (set of left & right pages)
	var slot = index % (TRIVIA_PER_PAGE * 2)  # Determine slot within spread
	var is_left = slot < TRIVIA_PER_PAGE  # Left page or right page?

	if spread < trivia_pages.size():
		var was_already_unlocked = false
		var fact_text = real_trivia[index]

		if is_left:
			was_already_unlocked = trivia_pages[spread]["unlocked_left"][slot]
			trivia_pages[spread]["texts_left"][slot] = fact_text
			trivia_pages[spread]["unlocked_left"][slot] = true
		else:
			var right_slot = slot - TRIVIA_PER_PAGE
			was_already_unlocked = trivia_pages[spread]["unlocked_right"][right_slot]
			trivia_pages[spread]["texts_right"][right_slot] = fact_text
			trivia_pages[spread]["unlocked_right"][right_slot] = true

		update_pages()
		return [!was_already_unlocked, index + 1, fact_text]

	return [false, index + 1, "Unknown Trivia"]
