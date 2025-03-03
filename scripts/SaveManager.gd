# Player / Game state information needs to be stored in a Dictionary (Godot equivalent of an object). These functions save/load/delete this data as a JSON when called.

extends Node

signal save_data_loaded # Signal so "inventory" waits for save to load

var save_path = "user://save_game.json"

#call inventory functions easy fix
var inventory = null

var hud = null

var volume = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	load_volume()


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
		
func set_inventory(inv):
	inventory = inv

func set_main_hud(hud_ref):
	hud = hud_ref

func load():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_as_text()
		file.close()

		var parsed_data = JSON.parse_string(data)
		
		
		if parsed_data != null:
			print("Successful game load.")
			PlayerData.apply_game_state(parsed_data)
					# add items back in easy fix
			if inventory != null:
				for i in range(PlayerData.inventory.size()):
					var saved_item = PlayerData.inventory[i]
					if saved_item != null:
						inventory.restore_item_at_slot(i, saved_item)
			if hud != null:
				for i in range(PlayerData.item_bar.size()):
					var saved_item = PlayerData.item_bar[i]
					if saved_item != null:
						hud.restore_item_bar(i, saved_item)

				# Restore potion bar directly into HUD
				for i in range(PlayerData.potion_bar.size()):
					var saved_potion = PlayerData.potion_bar[i]
					if saved_potion != null:
						hud.restore_potion_bar(i, saved_potion)

			
		else:
			print("Unsuccessful game load.")
	else:
		print("File does not exist")
		PlayerData.set_default_values()

func delete():
	# TODO: Make delete game force user back to main menu.
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path) # Be careful removing... deletes absolute path to given file/directory (if dir is empty)
		print("Save successfully deleted.")
	else:
		print("Failed to delete save. (No file)")
		

func set_volume(value):
	volume = value
	AudioServer.set_bus_volume_db(0, linear_to_db(volume))
	save_volume()

func save_volume():
	var config = ConfigFile.new()
	config.set_value("audio", "volume", volume)
	config.save("user://settings.cfg")

func load_volume():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		volume = config.get_value("audio", "volume", 1.0)
		AudioServer.set_bus_volume_db(0, linear_to_db(volume))
