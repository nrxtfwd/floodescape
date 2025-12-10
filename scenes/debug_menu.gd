extends VBoxContainer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('debug_menu'):
		visible = !visible

func _on_fly_pressed() -> void:
	pass # Replace with function body.
