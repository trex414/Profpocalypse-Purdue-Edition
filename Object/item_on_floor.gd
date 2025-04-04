extends Area2D

@export var item_data: Dictionary  # Contains type, name, count, texture, etc.

func _ready():
	if item_data.has("texture"):
		$Sprite2D.texture = item_data["texture"]

	connect("input_event", Callable(self, "_on_input"))

func _on_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var inventory = get_tree().get_first_node_in_group("Inventory")  # Add this node to the "Inventory" group
		if inventory and inventory.has_method("add_named_item"):
			if inventory.add_named_item(item_data["name"]):
				queue_free()  # Remove the item from the world
			else:
				print("Could not add item to inventory.")
