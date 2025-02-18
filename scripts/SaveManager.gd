# Player / Game state information needs to be stored in a Dictionary (Godot equivalent of an object). These functions save/load/delete this data as a JSON when called.

extends Node

var save_path = "user://save_game.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(PlayerData.get_game_state(), "\t"))
		file.close()
		print("Successful game save.")
	else:
		print("Unsuccessful game save (Failed to open file).")
		

func load():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_as_text()
		file.close()

		var parsed_data = JSON.parse_string(data)
		if parsed_data != null:
			print("Successful game load.")
			PlayerData.apply_game_state(parsed_data)
		else:
			print("Unsuccessful game load.")
	else:
		print("No save found.")
		# Could choose to create a new game here, if there is no save file found.
		# PlayerData.set_default_values()

func delete():
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path) # Be careful removing... deletes absolute path to given file/directory (if dir is empty)
		print("Save successfully deleted.")
	else:
		print("Failed to delete save. (No file)")
