extends CanvasLayer

@export var title : Label
@export var play : Button
@export var level_selection : PackedScene

func _on_play_pressed() -> void:
	Global.change_scene(level_selection)

func _on_play_mouse_entered() -> void:
	pass

func _on_play_mouse_exited() -> void:
	play.rotation = 0.0
