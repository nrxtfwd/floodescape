extends Node2D

@export var starting_scene : PackedScene
@export var fade : ColorRect

@onready var cg = $CanvasGroup

var cur_scene
var cur_scene_packed

func reload_scene():
	change_scene(cur_scene_packed)

func _ready() -> void:
	change_scene(starting_scene)

func change_scene(scene):
	Global.scene_changed.emit()
	fade.show()
	fade.modulate = Color.BLACK
	if cur_scene:
		cur_scene.queue_free()
	cur_scene_packed = scene
	var map = get_node_or_null('map')
	if map:
		map.queue_free()
	cur_scene = scene.instantiate()
	cg.add_child.call_deferred(cur_scene)
	var tween = get_tree().create_tween()
	tween.tween_property(fade, 'modulate', Color(1,1,1,0), 0.5)
