extends StaticBody2D

@export var key_pickup : CharacterBody2D

var key

func _ready() -> void:
	key = key_pickup.tool
	$keyhole.scale = Vector2(1.0/scale.x,1.0/scale.y)

func player_entered(body: Node2D) -> void:
	if body.tool != key:
		return
	body.destroy_tool()
	queue_free()
