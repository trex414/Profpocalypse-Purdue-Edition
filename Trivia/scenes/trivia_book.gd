extends Control

const TRIVIA_PER_PAGE = 3

var trivia_pages = []  # Stores all pages with 4 slots each

@onready var page_num_left = $CanvasLayer/Panel/PageNumLeft
@onready var page_num_right = $CanvasLayer/Panel/PageNumRight
@onready var counter = $CanvasLayer/Panel/Counter

var real_trivia = [
	"Purdue University was established in 1869, named after John Purdue!",
	"4 Purdue Petes are selected every year! He's currently the athletic mascot, but started as one for the University Book Store.",
	"Purdue adopted black and gold as its official colors in 1887!",
	"John Purdue was buried near his bronze statue in Memorial Mall. Rumor says his ghost appears after sundown.",
	"Purdue Football has the nickname \"The Cradle of Quarterbacks\" for its prominent quarterbacks!",
	"Purdue has 27 astronaut graduates, including Neil Armstrong in 1955!",
	"The Boilermaker Special is Purdue's official mascot, not Purdue Pete!",
	"Purdue bought Amelia Earhart the plane that she disappeared in. She served as a “Counselor on Careers for Women” in 1935!",
	"Legend says that if you walk under the bell tower, you won't graduate in 4 years.",
	"Built in 1877, University Hall is the only building remaining from Purdue's original six-building campus!",
	"Stone Hall is the former women's dormitory!",
	"Purdue's men's basketball team holds the record for most Big Ten regular season championships: 26!",
	"Clapping here in the clapping circle produces a sharp squeaky echo!",
	"Purdue is home to Indiana's first and only operating nuclear reactor. It's also open to tours!",
	"The Engineering Fountain was a gift from the class of 1939!",
	"Mackey Arena is the loudest Big 10 men's basketball area: it's reached 124.3 decibles!",
	"Haas Hall was originally the memorial gymnasium for the 1903 train accident. The 17 steps in front are for the 17 lives lost.",
	"Legend says Beering Hall has different zip codes for its top floors since John Purdue required that no building be taller than the original school building.",
	"Legend says the Math Building is considered a land bridge since John Purdue required that no building be taller than the original school building.",
	"If you and your significant other kiss under Purdue’s bell tower and walk by the Lion’s Fountain, then you will get married!",
	"There's a 6th floor of Cary Quad. It used to house the campus radio station, and has roof access!",
	"Rumor says that Amelia Earhart's ghost haunts the hangars.",
	"The inventor of chicken nuggets, Robert C. Baker, got his PhD from Purdue!",
	"Hilltop Apartments was originally built in 1949 for married students!",
	"Purdue Memorial Union opened in 1924! It's a memorian for students who fought in WWI.",
	"Purdue University has 10 colleges/schools!",
	"In 1921, Purdue completed construction of the largest bass drum in the world. The name is trademarked!",
	"Owen Hall is named after Purdue's first president in 1872, Richard Owen! The hall itself was opened in 1957.",
	"The CoRec is named after Purdue's eleventh president from 2007 to 2012, France Anne-Dominic Córdova!",
	"Hawkins Hall was renamed from Graduate House West in 1981 to honor George A. Hawkins!",
	"Hillenbrand Hall is home to the Data Mine program! Dr. Mark Daniel Ward launched it in 2018 with fewer than 100 student participants.",
	"Westwood Manor was built in 1932 as the private home of Robert B. Stewart, the vice president for business and finance. After he retired and donated it in 1971, it's the president's residence!",
	"The term \"Boilermakers\" came from an 1891 newspaper headline that referred to the year’s winning football team as \"Burly Boiler Makers from Purdue!\"",
	"The Grand Prix is 50-mile, 160-lap go-kart race with karts made from scratch by student teams! It began in 1958.",
	"Purdue Exponent was founded in 1889 and is Indiana’s largest collegiate daily newspaper, with approximately 150 student staff members!",
	"“Hail Purdue!”, Purdue's official fight song, was composed in 1912 by Edward Wotawa (music) and James Morrison (lyrics)!",
	"The Old Oaken Bucket, one of the nation’s oldest football trophies, goes to the winner of the annual Purdue-Indiana game, who adds a “P” or “I” link to its chain — though, the 1925 debut ended in a 0-0 tie, starting the chain with an “IP” link."
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
		#print("Player clicked NEXT, now on page:", current_page)

func prev_page():
	if current_page > 0:
		current_page -= 1
		update_pages()
		#print("Player clicked PREVIOUS, now on page:", current_page)
		
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
