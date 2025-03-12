extends Area2D

@export var new_music: AudioStream  # Assign the track for this area

var player_inside = false
var change_music_timer: Timer

func _ready():
	change_music_timer = Timer.new()
	add_child(change_music_timer)
	change_music_timer.wait_time = 0.5  # Small delay before switching
	change_music_timer.one_shot = true
	change_music_timer.timeout.connect(_change_music)

func _on_body_entered(body):
	print("Engineering Section Entered")
	if body.name == "TemporaryPlayer" and not player_inside:
		player_inside = true
		change_music_timer.start()  # Start timer

func _on_body_exited(body):
	print("Engineering Section Exited")
	if body.name == "TemporaryPlayer":
		player_inside = false
		change_music_timer.stop()  # Prevent changing if player leaves quickly

func _change_music():
	if player_inside:  # Ensure the player is still in the area
		var music_player = get_node("/root/MusicManager")
		MusicManager.play_music(new_music)
