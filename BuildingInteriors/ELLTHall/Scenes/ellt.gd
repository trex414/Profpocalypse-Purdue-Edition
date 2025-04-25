extends Node2D

var entered = false
var entered2 = true
var graduated = false
@onready var fade_rect = $ColorRect
@onready var exitpop = $UI/Control
@onready var exitpoplabel = $UI/Control/Panel/Label
@onready var streamer = $AnimatedSprite2D
@onready var streamer1 = $AnimatedSprite2D2
@onready var streamer2 = $AnimatedSprite2D3
@onready var streamer3 = $AnimatedSprite2D4
@onready var streamer4 = $AnimatedSprite2D5
@onready var music = $AudioStreamPlayer2D
@onready var label = $UI2/Control/Panel/Label
@onready var yes_button = $UI2/Control/Panel/HBoxContainer/ButtonYes
@onready var no_button = $UI2/Control/Panel/HBoxContainer/ButtonNo
@onready var control = $UI2/Control

func _ready():
	streamer.visible = false
	streamer1.visible = false
	streamer2.visible = false
	streamer3.visible = false
	streamer4.visible = false
	label.text = "Do you want to graduate?"
	yes_button.text = "Yes"
	no_button.text = "No"

	yes_button.pressed.connect(_on_yes_pressed)
	no_button.pressed.connect(_on_no_pressed)
	control.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if entered:
		exitpoplabel.text = ("Do you wish to exit?")
		exitpop.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	entered = true
	
	

func _on_area_2d2_body_entered(body: Node2D) -> void:
	if entered2 && !graduated:
		control.visible = true

func _on_area_2d2_body_exited(body: Node2D) -> void:
	entered2 = true
	


func _on_yes_pressed():
	graduated = true
	fade_and_do_something()

func _on_no_pressed():
	control.visible = false
	
	
func fade_out():
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.0)  # 1 sec fade to black

func fade_in():
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.0)  # 1 sec fade back to visible

func fade_and_do_something():
	control.visible = false
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.0)  # Fade out
	await tween.finished
	streamer.visible = true
	streamer1.visible = true
	streamer2.visible = true
	streamer3.visible = true
	streamer4.visible = true
	music.play()
	music.play()
	fade_in()
