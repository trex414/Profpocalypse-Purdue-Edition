@tool
extends Node2D

func _ready() -> void:
	var shader = load("res://Main Map/scenes/interactable_glow_shaders.gdshader")
	var hover_script = load("res://Main Map/scenes/trigger_glow.gd")

	for trivia in get_children():
		if trivia is Node2D:
			var sprites := []
			var areas := []

			# Recursively gather Sprite2D and Area2D
			for node in trivia.get_children():
				if node is Sprite2D:
					sprites.append(node)
				if node is Area2D:
					areas.append(node)

			# Assign shader to each sprite
			for sprite in sprites:
				var mat := ShaderMaterial.new()
				mat.shader = shader
				sprite.material = mat.duplicate()
				sprite.material.set_shader_parameter("glow_enabled", false)

			# Assign script to each Area2D
			for area in areas:
				area.set_script(hover_script)
				area._ready()
