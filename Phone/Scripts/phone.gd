extends Control

var courses = null
var settings = null
var achievements = null
var calendar = null
var abilities = null
var collections = null
var trivia = null
var quests = null

@onready var CoursesButton = $CanvasLayer/Panel/CoursesButton
@onready var SettingsButton = $CanvasLayer/Panel/SettingsButton
@onready var AchievementsButton = $CanvasLayer/Panel/AchievementsButton
@onready var CalendarButton = $CanvasLayer/Panel/CalendarButton
@onready var AbilitiesButton = $CanvasLayer/Panel/AbilitiesButton
@onready var CollectionsButton = $CanvasLayer/Panel/CollectionsButton
@onready var TriviaButton = $CanvasLayer/Panel/TriviaButton
@onready var QuestsButton = $CanvasLayer/Panel/QuestsButton
@onready var CloseButton = $CanvasLayer/Panel/CloseButton


func _ready():
	
	var panel = $CanvasLayer/Panel
	panel.visible = false
	
	CoursesButton.pressed.connect(_on_courses_pressed)
	SettingsButton.pressed.connect(_on_settings_pressed)
	AchievementsButton.pressed.connect(_on_achievements_pressed)
	CalendarButton.pressed.connect(_on_calendar_pressed)
	AbilitiesButton.pressed.connect(_on_abilities_pressed)
	CollectionsButton.pressed.connect(_on_collections_pressed)
	TriviaButton.pressed.connect(_on_trivia_pressed)
	QuestsButton.pressed.connect(_on_quests_pressed)
	CloseButton.pressed.connect(_on_close_pressed)

func toggle_Phone():
	$MajorInfoSFX.play()
	var panel = $CanvasLayer/Panel
	panel.visible = !panel.visible


func _on_courses_pressed():
	toggle_Phone()
	courses.toggle_MajorInfo()

func _on_settings_pressed():
	toggle_Phone()
	settings.toggle_menu()
	print("Settings")

func _on_achievements_pressed():
	toggle_Phone()
	achievements.toggle_achievements()
	print("Achievements")

func _on_calendar_pressed():
	toggle_Phone()
	calendar.toggle_calendar()

func _on_abilities_pressed():
	toggle_Phone()
	abilities.toggle_abilities()
	
func _on_collections_pressed():
	toggle_Phone()
	collections.toggle_Collections()
	print("Collections")

func _on_trivia_pressed():
	toggle_Phone()
	trivia.toggle_book()

func _on_quests_pressed():
	toggle_Phone()
	quests.toggle_questmenu()
	
func _on_close_pressed():
	toggle_Phone()
	
func set_courses(coursesRef: Control):
	courses = coursesRef

func set_settings(settingsRef: Control):
	settings = settingsRef
	
func set_achievements(achievementsRef: Control):
	achievements = achievementsRef

func set_calendar(calendarRef: Control):
	calendar = calendarRef

func set_abilities(abilitiesRef: Control):
	abilities = abilitiesRef
	
func set_collections(collectionsRef: Control):
	collections = collectionsRef

func set_trivia(triviaRef: Control):
	trivia = triviaRef

func set_quests(questsRef: Control):
	quests = questsRef
	
