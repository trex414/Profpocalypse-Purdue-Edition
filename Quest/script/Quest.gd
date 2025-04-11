extends Resource
class_name Quest

const Reward = preload("res://Quest/script/Reward.gd")

@export var quest_name: String = ""
@export var description: String = ""
@export var prerequisites: Array[Quest] = []
@export var rewards: Array[Reward] = []
@export var is_completed: bool = false
@export var pinned: bool = false
