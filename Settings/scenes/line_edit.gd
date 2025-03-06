extends LineEdit

@export var action_name: String

var listening_for_key = false



func _ready():
	print("here")
	text = get_current_key_name()
	connect("focus_entered", Callable(self, "_on_focus_entered"))

func _on_focus_entered():
	clear()
	listening_for_key = true

func _input(event):
	if listening_for_key and event is InputEventKey and event.pressed:
		listening_for_key = false
		var new_key = event.keycode
		
		remap_action(action_name, new_key)
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
