extends LineEdit

@export var action_name: String

var listening_for_key = false



func _ready():
	print("here")
	text = get_current_key_name()
	connect("focus_entered", Callable(self, "_on_focus_entered"))
	
	SaveManager.load()  # Ensure this loads the correct values from file
	
	
	remap_action("inventory_key", PlayerData.inventory_key)
	remap_action("move_left", PlayerData.move_left)
	remap_action("move_right", PlayerData.move_right)
	remap_action("move_up", PlayerData.move_up)
	remap_action("move_down", PlayerData.move_down)
	
	print("Final remapped values:")
	print("Inventory:", PlayerData.inventory_key)
	print("Move Left:", PlayerData.move_left)
	print("Move Right:", PlayerData.move_right)
	print("Move Up:", PlayerData.move_up)
	print("Move Down:", PlayerData.move_down)

func _on_focus_entered():
	clear()
	listening_for_key = true

func _input(event):
	if listening_for_key and event is InputEventKey and event.pressed:
		listening_for_key = false
		var new_key = event.keycode
		print("New Key Pressed: ", new_key)
		
		remap_action(action_name, new_key)
		print("Test ->", action_name)
		if action_name == "inventory_key":
			PlayerData.inventory_key = new_key
			print("i key", PlayerData.inventory_key)
		else: if action_name == "move_up":
			PlayerData.move_up = new_key
			print("up key", PlayerData.move_up)
		else: if action_name == "move_down":
			PlayerData.move_down = new_key
			print("down key", PlayerData.move_down)
		else: if action_name == "move_right":
			PlayerData.move_right = new_key
			print("right key", PlayerData.move_right)
		else: if action_name == "move_left":
			PlayerData.move_left = new_key
			print("left key", PlayerData.move_left)

		text = OS.get_keycode_string(new_key)
		release_focus()
		accept_event()

func get_current_key_name() -> String:
	var events = InputMap.action_get_events(action_name)
	if events.size() > 0:
		return OS.get_keycode_string(events[0].keycode)
	return ""

func remap_action(action: String, new_key: Key):
	InputMap.action_erase_events(action)
	
	var new_event = InputEventKey.new()
	new_event.keycode = new_key
	InputMap.action_add_event(action, new_event)
