extends Node

const SLOT_COUNT = 12  # Ensure it matches your main script
var inventory = []  # Stores inventory items in memory

func _ready():
	# Initialize empty inventory if not already set
	if inventory.size() == 0:
		for i in range(SLOT_COUNT):
			inventory.append(null)
