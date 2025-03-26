# EnemyManager.gd
extends Node

var enemies := []

func register_enemy(enemy_node):
	enemies.append(enemy_node)

func unregister_enemy(enemy_node):
	enemies.erase(enemy_node)

func get_closest_enemy():  # Just an example utility
	if enemies.size() > 0:
		return enemies[0]  # You can write logic to sort by distance
	return null
