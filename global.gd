extends Node

var tutorial_screen = null

var in_battle: bool = false

var advisorMeeting = null
var abilitiesMenu = null

#bleed
var status_effect_active := false
var status_effect_type := ""
var status_effect_turns_left := 0
var status_effect_damage_range := Vector2i(1, 3)



var enemy_database = {
	"Prof Doomsmore": {
		"name": "Prof Doomsmore",
		"max_health": 100,
		"level": 2,
		"damage": 1,
		"texture_path": "res://User_Battle/Sprites/Prof. Doomsmore.png"
	},
	"Prof Sel-Key": {
		"name": "Prof Sel-Key",
		"max_health": 125,
		"level": 5,
		"damage": 5,
		"texture_path": "res://User_Battle/Sprites/Prof. Sel-key.png"
	},
	"Prof Turkey": {
		"name": "Prof Turkey",
		"max_health": 150,
		"level": 8,
		"damage": 8,
		"texture_path": "res://User_Battle/Sprites/Prof. Turkey.png"
	}
}

# ---------- Battle Trivia Data ---------- #

var trivia_questions = [
	# Purdue Trivia
	{
		"question": "What year was Purdue University founded?",
		"choices": ["1869", "1848", "1890"],
		"correct": "1869"
	},
	{
		"question": "What is Purdue's mascot?",
		"choices": ["Boilermaker", "Hoosier", "Spartan"],
		"correct": "Boilermaker"
	},
	{
		"question": "Where is Purdue's main campus located?",
		"choices": ["West Lafayette", "Bloomington", "Indianapolis"],
		"correct": "West Lafayette"
	},
	{
		"question": "Which Big Ten school is Purdue's biggest rival?",
		"choices": ["Indiana University", "Ohio State", "Michigan"],
		"correct": "Indiana University"
	},
	{
		"question": "What is the name of Purdue’s football stadium?",
		"choices": ["Ross–Ade Stadium", "Mackey Arena", "Memorial Stadium"],
		"correct": "Ross–Ade Stadium"
	},
	{
		"question": "Which astronaut and Purdue alum was the first person on the Moon?",
		"choices": ["Neil Armstrong", "Buzz Aldrin", "Alan Shepard"],
		"correct": "Neil Armstrong"
	},
	{
		"question": "What is the Purdue Engineering mascot vehicle called?",
		"choices": ["The Boilermaker Special", "The Golden Train", "The Spirit Express"],
		"correct": "The Boilermaker Special"
	},
	{
		"question": "What is the student-run newspaper at Purdue?",
		"choices": ["The Exponent", "The Boiler Journal", "The Purdue Press"],
		"correct": "The Exponent"
	},
	{
		"question": "Which building on campus is home to many CS classes?",
		"choices": ["Lawson", "Beering", "Wetherill"],
		"correct": "Lawson"
	},
	{
		"question": "What is Purdue's school color combination?",
		"choices": ["Black and Gold", "Blue and White", "Red and Gray"],
		"correct": "Black and Gold"
	},

	# Computer Science Trivia
	{
		"question": "What does CPU stand for?",
		"choices": ["Central Processing Unit", "Computer Power Unit", "Control Program Unit"],
		"correct": "Central Processing Unit"
	},
	{
		"question": "Which data structure uses FIFO (First In, First Out)?",
		"choices": ["Queue", "Stack", "Tree"],
		"correct": "Queue"
	},
	{
		"question": "What language is often used to teach intro CS classes?",
		"choices": ["Python", "C++", "Ruby"],
		"correct": "Python"
	},
	{
		"question": "Which one is NOT a sorting algorithm?",
		"choices": ["Bubble Sort", "Quick Sort", "Fast Stack"],
		"correct": "Fast Stack"
	},
	{
		"question": "What does HTML stand for?",
		"choices": ["HyperText Markup Language", "HighText Machine Language", "HyperTool Markup Level"],
		"correct": "HyperText Markup Language"
	},
	{
		"question": "What is the output of 3 + '3' in most strongly typed languages?",
		"choices": ["Error", "33", "6"],
		"correct": "Error"
	},
	{
		"question": "What kind of loop continues while a condition is true?",
		"choices": ["While loop", "For loop", "Until loop"],
		"correct": "While loop"
	},
	{
		"question": "Which term refers to finding and fixing problems in code?",
		"choices": ["Debugging", "Deploying", "Compiling"],
		"correct": "Debugging"
	},
	{
		"question": "Which symbol is commonly used to indicate a comment in Python?",
		"choices": ["#", "//", "--"],
		"correct": "#"
	},
	{
		"question": "Which of the following is NOT a primitive data type in most languages?",
		"choices": ["Boolean", "Integer", "Tree"],
		"correct": "Tree"
	},
	{
		"question": "Which search algorithm halves the search space each step?",
		"choices": ["Binary Search", "Linear Search", "DFS"],
		"correct": "Binary Search"
	},
	{
		"question": "What is the time complexity of Bubble Sort in the worst case?",
		"choices": ["O(n^2)", "O(n log n)", "O(n)"],
		"correct": "O(n^2)"
	},
	{
		"question": "What does the 'int' keyword represent in most languages?",
		"choices": ["Integer", "Interval", "Interface"],
		"correct": "Integer"
	},
	{
		"question": "Which logic gate outputs true only when both inputs are true?",
		"choices": ["AND", "OR", "XOR"],
		"correct": "AND"
	},
	{
		"question": "What does IDE stand for in programming?",
		"choices": ["Integrated Development Environment", "Internal Debug Engine", "Input Data Executor"],
		"correct": "Integrated Development Environment"
	},

	# Trivia Book questions
	{
		"question": "Who was Purdue University named after?",
		"choices": ["John Purdue", "Neil Armstrong", "Richard Owen"],
		"correct": "John Purdue"
	},
	{
		"question": "How many Purdue Petes are selected each year?",
		"choices": ["4", "2", "1"],
		"correct": "4"
	},
	{
		"question": "When did Purdue adopt black and gold as its official colors?",
		"choices": ["1887", "1890", "1869"],
		"correct": "1887"
	},
	{
		"question": "Where is John Purdue buried?",
		"choices": ["Memorial Mall", "Behind Mackey Arena", "Engineering Fountain"],
		"correct": "Memorial Mall"
	},
	{
		"question": "What nickname does Purdue Football have?",
		"choices": ["The Cradle of Quarterbacks", "The Iron Boiler Line", "Boiler Smash"],
		"correct": "The Cradle of Quarterbacks"
	},
	{
		"question": "How many astronaut graduates does Purdue have?",
		"choices": ["27", "10", "15"],
		"correct": "27"
	},
	{
		"question": "What is Purdue’s official mascot?",
		"choices": ["Boilermaker Special", "Purdue Pete", "Golden Boiler"],
		"correct": "Boilermaker Special"
	},
	{
		"question": "What famous female aviator worked at Purdue and vanished in a plane funded by the university?",
		"choices": ["Amelia Earhart", "Sally Ride", "Bessie Coleman"],
		"correct": "Amelia Earhart"
	},
	{
		"question": "What happens if you walk under the bell tower at Purdue, according to legend?",
		"choices": ["You won't graduate in 4 years", "You’ll get married", "You’ll get a scholarship"],
		"correct": "You won't graduate in 4 years"
	},
	{
		"question": "Which building is the only one remaining from Purdue's original six?",
		"choices": ["University Hall", "Beering Hall", "Stone Hall"],
		"correct": "University Hall"
	},
	{
		"question": "What was Stone Hall originally used as?",
		"choices": ["A women's dormitory", "The first dining hall", "A chemistry lab"],
		"correct": "A women's dormitory"
	},
	{
		"question": "Which men's basketball team holds the record for most Big Ten regular season championships?",
		"choices": ["Purdue", "Michigan State", "Indiana University"],
		"correct": "Purdue"
	},
	{
		"question": "What happens when you clap in the clapping circle?",
		"choices": ["It creates a sharp squeaky echo", "It lights up", "It activates the fountain"],
		"correct": "It creates a sharp squeaky echo"
	},
	{
		"question": "What is Indiana’s only operating nuclear reactor open for tours located?",
		"choices": ["Purdue", "IU Bloomington", "Notre Dame"],
		"correct": "Purdue"
	},
	{
		"question": "What class gifted the Engineering Fountain?",
		"choices": ["Class of 1939", "Class of 2000", "Class of 1900"],
		"correct": "Class of 1939"
	},
	{
		"question": "What was the highest recorded decibel level in Mackey Arena?",
		"choices": ["124.3", "108.9", "119.5"],
		"correct": "124.3"
	},
	{
		"question": "What do the 17 steps outside Haas Hall represent?",
		"choices": ["17 students who died in a train accident", "The number of Big Ten schools", "17 Boilermaker specials"],
		"correct": "17 students who died in a train accident"
	},
	{
		"question": "What is the myth about Beering Hall's height?",
		"choices": ["It has different zip codes for top floors", "It floats during storms", "It glows at night"],
		"correct": "It has different zip codes for top floors"
	},
	{
		"question": "Why is the Math Building considered a land bridge?",
		"choices": ["To obey John Purdue's height restrictions", "To save on heating costs", "To resist earthquakes"],
		"correct": "To obey John Purdue's height restrictions"
	},
	{
		"question": "According to legend, if you kiss under the bell tower and walk by the Lion's Fountain, what happens?",
		"choices": ["You’ll get married", "You’ll get engaged", "You’ll graduate early"],
		"correct": "You’ll get married"
	},
	{
		"question": "Where was Purdue’s old campus radio station located?",
		"choices": ["6th floor of Cary Quad", "3rd floor of Hicks", "Under Mackey Arena"],
		"correct": "6th floor of Cary Quad"
	},
	{
		"question": "Whose ghost is rumored to haunt Purdue's hangars?",
		"choices": ["Amelia Earhart", "Neil Armstrong", "Richard Owen"],
		"correct": "Amelia Earhart"
	},
	{
		"question": "Who invented chicken nuggets and got a PhD from Purdue?",
		"choices": ["Robert C. Baker", "Colonel Sanders", "Paul Purdue"],
		"correct": "Robert C. Baker"
	},
	{
		"question": "What were Hilltop Apartments originally built for in 1949?",
		"choices": ["Married students", "Graduate students", "Football players"],
		"correct": "Married students"
	},
	{
		"question": "What year did the Purdue Memorial Union open?",
		"choices": ["1924", "1912", "1940"],
		"correct": "1924"
	},
	{
		"question": "How many colleges/schools does Purdue have?",
		"choices": ["10", "12", "8"],
		"correct": "10"
	},
	{
		"question": "What is the name of Purdue's enormous trademarked drum?",
		"choices": ["Big Bass Drum", "Boiler Drum", "Purdue Thunder"],
		"correct": "Big Bass Drum"
	},
	{
		"question": "Who is Owen Hall named after?",
		"choices": ["Purdue's first president", "John Purdue", "Purdue Pete’s designer"],
		"correct": "Purdue's first president"
	},
	{
		"question": "Who is the CoRec named after?",
		"choices": ["France A. Córdova", "Amelia Earhart", "Mitch Daniels"],
		"correct": "France A. Córdova"
	},
	{
		"question": "Who was Hawkins Hall named after in 1981?",
		"choices": ["George A. Hawkins", "John Purdue", "Harry Hawkins"],
		"correct": "George A. Hawkins"
	},
	{
		"question": "Which dorm is home to the Data Mine program?",
		"choices": ["Hillenbrand Hall", "Earhart Hall", "Shreve Hall"],
		"correct": "Hillenbrand Hall"
	},
	{
		"question": "Where does Purdue’s president live?",
		"choices": ["Westwood Manor", "Lawson Hall", "Hovde Hall"],
		"correct": "Westwood Manor"
	},
	{
		"question": "Where did the nickname 'Boilermakers' come from?",
		"choices": ["An 1891 newspaper headline", "The first mascot's job", "A steel industry partnership"],
		"correct": "An 1891 newspaper headline"
	},
	{
		"question": "What is the Grand Prix?",
		"choices": ["A 50-mile go-kart race", "Purdue's elite scholarship program", "A science fair"],
		"correct": "A 50-mile go-kart race"
	},
	{
		"question": "When was the Purdue Exponent founded?",
		"choices": ["1889", "1910", "1855"],
		"correct": "1889"
	},
	{
		"question": "When was 'Hail Purdue!' composed?",
		"choices": ["1912", "1900", "1924"],
		"correct": "1912"
	},
	{
		"question": "What does the winning team add to the Old Oaken Bucket trophy?",
		"choices": ["A letter link", "A football sticker", "A Boilermaker charm"],
		"correct": "A letter link"
	}
]
