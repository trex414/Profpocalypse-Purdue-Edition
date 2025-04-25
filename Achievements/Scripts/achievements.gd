extends Control

# 12 achievements — true means unlocked


# Individual nodes
@onready var Label1 = $CanvasLayer/Panel/Label1
@onready var Label2 = $CanvasLayer/Panel/Label2
@onready var Label3 = $CanvasLayer/Panel/Label3
@onready var Label4 = $CanvasLayer/Panel/Label4
@onready var Label5 = $CanvasLayer/Panel/Label5
@onready var Label6 = $CanvasLayer/Panel/Label6
@onready var Label7 = $CanvasLayer/Panel/Label7
@onready var Label8 = $CanvasLayer/Panel/Label8
@onready var Label9 = $CanvasLayer/Panel/Label9
@onready var Label10 = $CanvasLayer/Panel/Label10
@onready var Label11 = $CanvasLayer/Panel/Label11
@onready var Label12 = $CanvasLayer/Panel/Label12

@onready var TextureRect1 = $CanvasLayer/Panel/TextureRect1
@onready var TextureRect2 = $CanvasLayer/Panel/TextureRect2
@onready var TextureRect3 = $CanvasLayer/Panel/TextureRect3
@onready var TextureRect4 = $CanvasLayer/Panel/TextureRect4
@onready var TextureRect5 = $CanvasLayer/Panel/TextureRect5
@onready var TextureRect6 = $CanvasLayer/Panel/TextureRect6
@onready var TextureRect7 = $CanvasLayer/Panel/TextureRect7
@onready var TextureRect8 = $CanvasLayer/Panel/TextureRect8
@onready var TextureRect9 = $CanvasLayer/Panel/TextureRect9
@onready var TextureRect10 = $CanvasLayer/Panel/TextureRect10
@onready var TextureRect11 = $CanvasLayer/Panel/TextureRect11
@onready var TextureRect12 = $CanvasLayer/Panel/TextureRect12

@onready var Lock1 = $CanvasLayer/Panel/Lock1
@onready var Lock2 = $CanvasLayer/Panel/Lock2
@onready var Lock3 = $CanvasLayer/Panel/Lock3
@onready var Lock4 = $CanvasLayer/Panel/Lock4
@onready var Lock5 = $CanvasLayer/Panel/Lock5
@onready var Lock6 = $CanvasLayer/Panel/Lock6
@onready var Lock7 = $CanvasLayer/Panel/Lock7
@onready var Lock8 = $CanvasLayer/Panel/Lock8
@onready var Lock9 = $CanvasLayer/Panel/Lock9
@onready var Lock10 = $CanvasLayer/Panel/Lock10
@onready var Lock11 = $CanvasLayer/Panel/Lock11
@onready var Lock12 = $CanvasLayer/Panel/Lock12

# Grouped into arrays for looping
@onready var label_nodes = [
	Label1, Label2, Label3, Label4,
	Label5, Label6, Label7, Label8,
	Label9, Label10, Label11, Label12
]

@onready var icon_nodes = [
	TextureRect1, TextureRect2, TextureRect3, TextureRect4,
	TextureRect5, TextureRect6, TextureRect7, TextureRect8,
	TextureRect9, TextureRect10, TextureRect11, TextureRect12
]

@onready var lock_nodes = [
	Lock1, Lock2, Lock3, Lock4,
	Lock5, Lock6, Lock7, Lock8,
	Lock9, Lock10, Lock11, Lock12
]

@onready var panel = $CanvasLayer/Panel
@onready var close_button = $CanvasLayer/Panel/TextureButton
	
func _ready():
	panel.visible = false
	update_achievements()
	close_button.pressed.connect(toggle_achievements)


func update_achievements():
	for i in range(0, 12, 1):
		var unlocked = PlayerData.achievements_unlocked[i]
		print(str(unlocked))
		if i == 11:
			unlocked = false
		icon_nodes[i].visible = unlocked
		label_nodes[i].visible = unlocked
		lock_nodes[i].visible = not unlocked

		
func toggle_achievements():
	panel.visible = !panel.visible
	if panel.visible:
		update_achievements()
