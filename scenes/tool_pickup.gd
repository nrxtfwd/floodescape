extends CharacterBody2D

@export var tool : Tool = load('res://resources/tools/key.tres')

var disabled = false
var gravity = false

func _ready() -> void:
	$sprite.texture = tool.tool_texture
	await get_tree().create_timer(0.5).timeout
	disabled = false

func player_entered(body: Node2D) -> void:
	if disabled:
		return
	body.tool = tool
	queue_free()

func _physics_process(delta: float) -> void:
	if is_on_floor():
		velocity.y = 0
		velocity.x = move_toward(velocity.x, 0, 2.0)
	else:
		if gravity:
			velocity.y += 5.0
	move_and_slide()
