@tool  # Allows running in the editor
extends Node2D
			
func _ready():
	for building in get_children():
		if building is Area2D:
			# Remove existing StaticBody2D
			for child in building.get_children():
				if child is StaticBody2D:
					building.remove_child(child)
					child.queue_free()
				if child is Label:
					child.set_z_index(5)

			var static_body = StaticBody2D.new()
			static_body.name = "StaticBody2D"
			building.add_child(static_body)
			static_body.owner = get_tree().edited_scene_root

			# Look for CollisionPolygon2D nodes directly under the building
			for area_collision in building.get_children():
				if area_collision is CollisionPolygon2D:
					var new_collision = CollisionPolygon2D.new()
					new_collision.polygon = area_collision.polygon.duplicate()

					# Align to world
					building.add_child(new_collision)  # temp add to match world coords
					new_collision.global_transform = area_collision.global_transform
					building.remove_child(new_collision)

					# Then reparent under static_body with transform intact
					static_body.add_child(new_collision)
					new_collision.owner = get_tree().edited_scene_root
