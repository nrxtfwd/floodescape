extends Level

@export var flood2 : Area2D
@export var flood3 : Area2D

func transitioned() -> void:
	await get_tree().create_timer(7.0).timeout
	flood2.velocity = Vector2(0,-0.2)
