@tool  # Allows running in the editor
extends Node2D

func _ready():
	for building in get_children():
		if building is Area2D:
			# Remove any existing StaticBody2D nodes
			for child in building.get_children():
				if child is StaticBody2D:
					building.remove_child(child)
					child.queue_free()  # Marks for deletion
				if child is Label:
					child.set_z_index(5)

			# Create a new StaticBody2D if none exists
			var static_body = StaticBody2D.new()
			static_body.name = "StaticBody2D"
			static_body.position = building.position  # Align positions

			# Copy all CollisionPolygon2D children
			for area_collision in building.get_children():
				if area_collision is CollisionPolygon2D:
					var new_collision = CollisionPolygon2D.new()
					
					# Duplicate the polygon shape
					new_collision.polygon = area_collision.polygon.duplicate()
					
					# Keep the same position & transform
					new_collision.position = area_collision.position
					new_collision.rotation = area_collision.rotation
					new_collision.scale = area_collision.scale

					static_body.add_child(new_collision)
					new_collision.owner = get_tree().edited_scene_root  # Ensure saving

			building.add_child(static_body)
			static_body.owner = get_tree().edited_scene_root  # Ensure saving
