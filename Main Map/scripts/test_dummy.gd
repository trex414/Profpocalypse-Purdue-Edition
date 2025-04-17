extends Node2D

@export var enemy_name: String
@export var enemy_node_path: NodePath

var enemy_instance

func trigger_cutscene():
	var hud = get_tree().current_scene.get_node("Control - HUD")
	var battle_ui = hud.battle_ui

	enemy_instance = get_node(enemy_node_path)

	battle_ui.start_cutscene(enemy_name, enemy_instance)


func _on_body_entered(body):
	print("Entered body: ", body.name)
	if body.name == "TemporaryPlayer":
		trigger_cutscene()
