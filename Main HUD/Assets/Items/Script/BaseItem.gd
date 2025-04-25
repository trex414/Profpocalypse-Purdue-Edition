extends Resource
class_name BaseItem

@export var item_name: String
@export var texture: Texture2D
@export var item_type: int
@export var stackable: bool
@export var count: int = 1
@export var itemstrength: int

enum ItemType { ITEM, SPELL }
