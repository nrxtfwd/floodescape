extends Node2D
class_name Level

@export var next_level : PackedScene
@export var level_id : String

var stars = 0 :
	set(value):
		stars = value
		Global.stars_changed.emit(stars)

func _ready() -> void:
	Global.level_changed.emit(level_id)
