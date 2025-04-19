extends Node2D

@onready var speech_label = $Message

@export var item: String = ""
@export var npc_id: String = ""

var inventorymanager = null
var inventory = null

func _ready():
	speech_label.visible = false
	
	inventorymanager = get_node("/root/InventoryManager")

func _on_mouse_entered():
	speech_label.visible = true

func _on_mouse_exited():
	speech_label.visible = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		give_reward()

func give_reward():
	if PlayerData.npc_rewards.get(npc_id, false):
		print("Reward already given!")
		return

	if !inventorymanager.inventory_node.add_named_item(item):
		prompt_inventory_full(item)
		return

	# Reward logic
	print("Reward given!")
	PlayerData.npc_rewards[npc_id] = true

func prompt_inventory_full(new_item):
	print("Inventory is full! Make room for: " + new_item)
