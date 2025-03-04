extends Resource
class_name Quest

@export var quest_name: String = ""
@export var description: String = ""
@export var prerequisites: Array[Quest] = []
@export var rewards: Array[String] = []
@export var is_completed: bool = false
@export var pinned: bool = false
