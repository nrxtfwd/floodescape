extends Node

var player
var scene_manager
var completed_levels = []
var total_stars = 0 :
	set(value):
		total_stars = value
		total_stars_changed.emit(total_stars)

signal died
signal total_stars_changed
signal level_changed
signal stars_changed
signal scene_changed

func _ready() -> void:
	scene_manager = get_tree().current_scene

func tick():
	return Time.get_ticks_msec()/1000.0

func change_scene(scene):
	scene_manager.change_scene(scene)

func scene():
	return scene_manager.cur_scene
