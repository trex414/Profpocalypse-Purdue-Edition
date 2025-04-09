# Potions.gd
# This script handles potion logic separately from the HUD.
extends Node

# Function to handle health potion consumption
func use_health_potion(health_manager, item):
	if health_manager == null:
		print("ERROR: HealthManager reference is missing!")
		return false
	
	# Use the heal_amount from the item definition; default to 20 if not provided.
	#var heal_amt = item.get("heal_amount", 10)
	var heal_amount = item.get("heal_amount", 0)
	if health_manager.current_health < health_manager.max_health:
		health_manager.add_health(heal_amount)
		print("Health Potion used! Health increased by %d." % heal_amount)
		return true
	else:
		print("Health is already full. Cannot use potion.")
		return false

# Function to handle experience potion consumption
func use_exp_potion(exp_manager, item):
	if exp_manager == null:
		print("ERROR: EXPManager reference is missing!")
		return false
	
	# Use the exp_amount from the item definition; default to 1 if not provided.
	var exp_amt = item.get("exp_amount", 1)
	exp_manager.add_exp(exp_amt)
	print("EXP Potion used! Gained %d experience." % exp_amt)
	return true
