# inventory_manager.gd
# This script is built to inisilize the inventory
extends Node

# inventory variables
const SLOT_COUNT = 12
var inventory = []

func _ready():
	# Initialize empty inventory if not already set
	if inventory.size() == 0:
		for i in range(SLOT_COUNT):
			inventory.append(null)
