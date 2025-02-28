# inventory_manager.gd
# This script is built to inisilize the inventory
extends Node

# inventory variables
const SLOT_COUNT = 12
var inventory = []

func _ready():
	#SaveManager.connect("save_data_loaded", Callable(self, "_on_save_data_loaded"))
	#print("Waiting for SaveManager to load...")
	print("SaveManager finished loading, now initializing inventory.")
	inventory = PlayerData.inventory.duplicate(true)
	print("========1 inventory: ", inventory)
	
	# Initialize empty inventory if not already set
	if inventory.size() == 0:
		print("Inventory save NOT detected. <============")
		for i in range(SLOT_COUNT):
			inventory.append(null)
	else:
		print("Inventory save detected. <============")
		for i in range(SLOT_COUNT):
			inventory.append(PlayerData.inventory[i])

func _on_save_data_loaded():
	print("SaveManager finished loading, now initializing inventory.")
	inventory = PlayerData.inventory.duplicate(true)
	print("========1 inventory: ", inventory)
	
	# Initialize empty inventory if not already set
	if inventory.size() == 0:
		print("Inventory save NOT detected. <============")
		for i in range(SLOT_COUNT):
			inventory.append(null)
	else:
		print("Inventory save detected. <============")
		for i in range(SLOT_COUNT):
			inventory.append(PlayerData.inventory[i])
