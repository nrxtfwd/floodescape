extends Camera2D

@onready var upper = $upper
@onready var lower = $lower

var last_adjusted = 0

func _physics_process(delta: float) -> void:
	var tick = Global.tick()
	var player_y = Global.player.global_position.y
	if player_y < upper.global_position.y or player_y > lower.global_position.y:
		if tick - last_adjusted >= 0.5:
			global_position.y = player_y
			last_adjusted = tick
