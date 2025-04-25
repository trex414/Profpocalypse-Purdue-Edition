# Player / Game state information needs to be stored in a Dictionary (Godot equivalent of an object). These functions save/load/delete this data as a JSON when called.

extends Node

signal save_data_loaded # Signal so "inventory" waits for save to load

var save_path = "user://save_game.json"
var config = ConfigFile.new()

@onready var root_node = get_tree().current_scene

#call inventory functions easy fix
var inventory = null

var hud = null

var volume = 1.0
var brightness = 1.0

#built to test latency
static var game_start_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	game_start_time = Time.get_ticks_msec()
	load_volume()
	load_brightness()
	


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
		
	if FileAccess.file_exists("user://settings.cfg"):
		DirAccess.remove_absolute("user://settings.cfg")
		
		# Overwrite last saved character with default
	var default_path = "res://CharacterCustomization/CustomCharacters/default.json"
	var last_save_path = "res://CharacterCustomization/last_saved_character.json"

	if FileAccess.file_exists(default_path):
		var default_file = FileAccess.open(default_path, FileAccess.READ)
		var default_data = default_file.get_as_text()
		default_file.close()

		var overwrite_file = FileAccess.open(last_save_path, FileAccess.WRITE)
		overwrite_file.store_string(default_data)
		overwrite_file.close()

		print("✅ last_saved_character.json successfully overwritten with default.")
	else:
		print("❌ Default character file not found.")
		

func set_volume(value):
	volume = value
	AudioServer.set_bus_volume_db(0, linear_to_db(volume))
	save_volume()

func save_volume():
	config.set_value("audio", "volume", volume)
	config.save("user://settings.cfg")

func load_volume():
	if config.load("user://settings.cfg") == OK:
		volume = config.get_value("audio", "volume", 1.0)
		AudioServer.set_bus_volume_db(0, linear_to_db(volume))
		

func set_brightness(value):
	brightness = value
	root_node.modulate = Color(value, value, value, 1)
	save_brightness()
	

func save_brightness():
	config.set_value("graphics", "brightness", brightness)
	config.save("user://settings.cfg")
	
func load_brightness():
	if config.load("user://settings.cfg") == OK:
		brightness = config.get_value("graphics", "brightness", 1.0)
		root_node.modulate = Color(brightness, brightness, brightness, 1)
