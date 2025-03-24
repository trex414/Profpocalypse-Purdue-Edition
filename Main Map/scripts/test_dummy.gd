extends Node2D

func trigger_cutscene():
	var battle_ui = preload("res://User_Battle/Scene/battle_ui.tscn").instantiate()

	# Grab player texture from the main map
	var player_sprite = get_tree().get_current_scene().get_node("Map/TemporaryPlayer/Sprite2D")
	var player_texture = player_sprite.texture
	
	if player_texture == null:
		print("⚠️ Player texture is null — applying fallback white box.")
		var img = Image.create(32, 32, false, Image.FORMAT_RGBA8)
		img.fill(Color.WHITE)
		player_texture = ImageTexture.create_from_image(img)
	print("Player texture:", player_texture)


	# Wait for UI to initialize then assign texture
	get_tree().current_scene.add_child(battle_ui)
	await get_tree().process_frame  # wait one frame after adding

	battle_ui.set_player_texture(player_texture)




func _on_body_entered(body):
	print("Entered body: ", body.name)  # Debugging
	if body.name == "TemporaryPlayer":
		trigger_cutscene()
