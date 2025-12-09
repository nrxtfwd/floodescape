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

func run_fade(dur = 0.5):
	fade.show()
	fade.modulate = Color.BLACK
	await get_tree().create_timer(dur * 0.2).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(fade, 'modulate', Color(1,1,1,0), dur * 0.8)

func change_scene(scene):
	Global.scene_changed.emit()
	
	if cur_scene:
		cur_scene.queue_free()
	cur_scene_packed = scene
	var map = get_node_or_null('map')
	if map:
		map.queue_free()
	cur_scene = scene.instantiate()
	cg.add_child.call_deferred(cur_scene)
	run_fade()
	
