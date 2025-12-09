extends CharacterBody2D

func player_entered(body: Node2D) -> void:
	velocity = Vector2(0,10.0)

func _physics_process(delta: float) -> void:
	move_and_slide()
