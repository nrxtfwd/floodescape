extends CharacterBody2D

var gravity = false
var shaking = false
var initial_pos
var shake_offset = 2.0

func _ready() -> void:
	initial_pos = global_position

func player_entered(body: Node2D) -> void:
	shaking = true
	await get_tree().create_timer(1.0).timeout
	gravity = true
	

func _physics_process(delta: float) -> void:
	if gravity:
		velocity.y += 9.0
		if get_slide_collision_count() > 0:
			for i in get_slide_collision_count():
				if get_slide_collision(i).get_collider() is TileMapLayer:
					queue_free()
	elif shaking:
		global_position = initial_pos + Vector2( 
			randf() * shake_offset - shake_offset/2.0,
			randf() * shake_offset - shake_offset/2.0
		)
	move_and_slide()
