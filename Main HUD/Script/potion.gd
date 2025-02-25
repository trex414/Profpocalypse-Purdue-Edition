# Potions.gd
# This script handles potion logic separately from the HUD.
extends Node

# Function to handle health potion consumption
func use_health_potion(health_manager, item):
	if health_manager == null:
		#DEBUG
		print("ERROR: HealthManager reference is missing!")
		return
	
	if health_manager.current_health < health_manager.max_health:
		health_manager.add_health(20)
		print("Health Potion used! Health increased.")
		return true
	else:
		print("Health is already full. Cannot use potion.")
		return false

# Function to handle experience potion consumption
func use_exp_potion(exp_manager, item):
	if exp_manager == null:
		#DEBUG
		print("ERROR: EXPManager reference is missing!")
		return
	exp_manager.add_exp(1)
	print("EXP Potion used! Gained experience.")
	return true
