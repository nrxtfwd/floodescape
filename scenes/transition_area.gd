extends Area2D

@export var camera : Camera2D
@export var camera_pos : Node2D
@export var player_pos : Node2D
@export var fade_duration = 1.0
@export var only_from = 0

func _ready() -> void:
	if !get_node_or_null('camera_pos') and !camera_pos:
		push_error("NO CAMERA POS NODE IN TRANSITION AREA")
	if !get_node_or_null('player_pos') and !player_pos:
		push_error("NO PLAYER POS NODE IN TRANSITION AREA")

func player_entered(body: Node2D) -> void:
	if only_from != 0:
		if body.velocity.x < 0 and only_from > 0:
			return
		if body.velocity.x > 0 and only_from < 0:
			return
	Global.scene_manager.run_fade(fade_duration)
	camera.global_position = camera_pos.global_position
	Global.player.global_position = player_pos.global_position
