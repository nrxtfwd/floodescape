extends ColorRect

func died():
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'modulate', Color.WHITE, 0.2)

func _ready() -> void:
	Global.died.connect(died)

func _on_button_pressed() -> void:
	if modulate != Color.WHITE:
		return
	modulate = Color(1,1,1,0)
	Global.scene_manager.reload_scene()
