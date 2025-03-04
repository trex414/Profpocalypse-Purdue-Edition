extends SubViewport

@onready var camera = $Camera2D

func _ready():
	camera.make_current()

func _physics_process(_delta):
	camera.position = owner.find_child("TemporaryPlayer").position + Vector2(1010, -1100)
