extends StaticBody2D

func _process(delta: float) -> void:
	var player_y = Global.player.global_position.y
	var y = global_position.y
	$col_shape.disabled = player_y > y or abs(player_y - y) <= 8.0 or Input.is_action_pressed('down')
