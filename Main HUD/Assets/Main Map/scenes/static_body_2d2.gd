extends StaticBody2D

var item_name = "Sword of Truth"

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var inventory = get_tree().get_first_node_in_group("Inventory")
		if inventory and inventory.has_method("add_named_item"):
			if inventory.add_named_item(item_name):
				print("Item picked up:", item_name)
				queue_free()
			else:
				print("Inventory full. Could not pick up.")
