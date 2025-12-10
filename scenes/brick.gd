extends StaticBody2D

var stage = 0
var last_break = 0

@export var max_bricks : int = 100
@export var break_chance : float = 0.5

func _ready() -> void:
	pass
	#$crack.rotation = (PI/4.0) * randi_range(1,4)

func break_brick(brick, counter):
	if !('player_entered') in brick:
		return
	brick.player_entered(counter - 1)

func player_entered(counter) -> void:
	if !Global.player.tool or Global.player.tool.tool_name != 'Pickaxe':
		return
	if typeof(counter) != TYPE_INT:
		counter = max_bricks
	if counter <= 0:
		return
	var tick = Global.tick()
	if tick - last_break <= 0.3:
		return
	last_break = tick
	stage += 1
	$crack.visible = stage >= 1
	if $right.is_colliding():
		break_brick($right.get_collider(), counter)
	if $left.is_colliding():
		break_brick($left.get_collider(), counter)
	if $up.is_colliding():
		break_brick($up.get_collider(), counter)
	if $down.is_colliding():
		break_brick($down.get_collider(), counter)
	if stage >= 1:
		modulate = Color.GRAY
	if stage >= 2:
		var destroyed = $destroyed
		destroyed.emitting = true
		destroyed.reparent.call_deferred(Global.scene())
		destroyed.finished.connect(
			func():
				destroyed.queue_free()
		)
		queue_free()
