extends AudioStreamPlayer

@onready var audio_player: AudioStreamPlayer = $"/root/MusicManager"

var current_music = null
var last_music = null

func play_music(new_track: AudioStream):
	if audio_player.stream != new_track:
		var tween = create_tween()
		tween.tween_property(audio_player, "volume_db", -30, 1.0)  # Fade out over 1 second
		await tween.finished
		audio_player.stream = new_track
		audio_player.play()
		tween = create_tween()
		tween.tween_property(audio_player, "volume_db", 0, 1.0)  # Fade in new track
		
		current_music = new_track

func play_battle_music(new_track: AudioStream):
	last_music = current_music
	play_music(new_track)
	
func restore_previous_music():
	play_music(last_music)
	last_music = null
