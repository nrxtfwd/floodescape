extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -320.0

@export var camera : Camera2D
@export var pickup : PackedScene

@onready var anim_player = $AnimationPlayer
@onready var walk_particles = $walk_particles

var destroy_cur_tool = false
var last_jumped = 0
var died = false
var tool : Tool = null :
	set(value):
		
		if tool and !destroy_cur_tool:
			var t_p = pickup.instantiate()
			t_p.global_position = global_position
			t_p.disabled = true
			t_p.velocity = Vector2.ZERO
			t_p.gravity = true
			t_p.tool = tool
			Global.scene().add_child.call_deferred(t_p)
		tool = value
		if tool:
			$tool.texture = tool.tool_texture
		$tool.visible = true if tool else false
		destroy_cur_tool = false
var last_wall_jump = 0
var was_underwater = false
var last_on_floor = -100.0
var on_ladder = false
var in_air_from_jump = false
var is_underwater = false
var water_jump = false
var got_on_ladder = 0
var oxygen = 100 :
	set(value):
		oxygen = min(max(value, 0.0), 100.0)
		oxygen_changed.emit(value/100.0)
		if oxygen <= 0 and !died:
			died = true
			Global.died.emit()

signal oxygen_changed
signal oxygen_bar_update

func destroy_tool():
	destroy_cur_tool = true
	tool = null

func _ready() -> void:
	Global.player = self

func _physics_process(delta: float) -> void:
	if died:
		return
	
	var tick = Global.tick()
	var is_wall_jumping = len($wall_jump.get_overlapping_bodies()) > 0 and tick - last_jumped > 0.2
	is_underwater = len($water.get_overlapping_areas()) > 0
	if not is_on_floor():
		if !is_wall_jumping:
			var mul = 1.0
			if in_air_from_jump:
				if abs(velocity.y) <= 10.0:
					mul = 0.7
				elif velocity.y > 0:
					mul = 2.2
			velocity.y += 1100.0 * delta * mul
	else:
		in_air_from_jump = false
		last_on_floor = tick
		water_jump = false
	
	if is_wall_jumping:
		rotation = 0
		velocity.y = 0
	
	var jump_from_water = (was_underwater and !is_underwater)
	var pressing_jump = Input.is_action_pressed("jump")
	var can_jump = pressing_jump and ((tick - last_on_floor <= 0.23 and tick - last_jumped > 0.45) or (is_wall_jumping))
	if can_jump or jump_from_water:
		velocity.y = JUMP_VELOCITY
		if is_wall_jumping:
			var polarity = 0
			if $wj_left.is_colliding():
				polarity = 1.0
			else:
				polarity = -1.0
			velocity.x = polarity * SPEED
			last_wall_jump = tick
		last_jumped = tick
		anim_player.stop()
		anim_player.play('squash')
		var jump = $jump.duplicate()
		jump.emitting = true
		add_child(jump)
		jump.finished.connect(
			func():
				jump.queue_free()
		)
		if jump_from_water:
			var flip_dir = sign(velocity.x)
			if flip_dir != 0:
				water_jump = flip_dir
		else:
			in_air_from_jump = true
	if pressing_jump:
		if tick - last_jumped <= 0.1:
			velocity.y -= 20.0
	if water_jump:
		rotation += (1.0/360.0) * 2.0 * PI * 3.0 * water_jump
	
	var direction := Input.get_axis("left", "right")
	if !is_underwater:
		if is_on_floor():
			rotation = 0
		if !is_wall_jumping and tick - last_wall_jump > 0.3:
			if on_ladder:
				velocity.y = Input.get_axis('up', 'down') * SPEED
			if !on_ladder or (tick - got_on_ladder) > 0.3:
				if direction:
					velocity.x = direction * SPEED
				else:
					velocity.x = move_toward(velocity.x, 0, SPEED)
		oxygen += 0.3
	else:
		oxygen -= 0.8
		var swim_dir = Input.get_vector('left', 'right', 'up', 'down') * SPEED
		if pressing_jump:
			swim_dir.y = -1.0
		velocity = velocity.move_toward(swim_dir, SPEED * 0.2)
		if direction:
			look_at(global_position + velocity)
			rotation += PI /2.0
		else:
			rotation += (1.0/360.0) * 2.0 * PI
	$swim.emitting = is_underwater
	
	if direction:
		$tool.offset.x = 8.0 * direction
		$tool.flip_h = direction < 0
	
	walk_particles.emitting = direction and is_on_floor()
	move_and_slide()
	was_underwater = is_underwater

func _on_ladder_body_entered(body: Node2D) -> void:
	velocity.x = 0
	on_ladder = true
	got_on_ladder = Global.tick()

func _on_ladder_body_exited(body: Node2D) -> void:
	on_ladder = false

func finished(body: Node2D) -> void:
	Global.completed_levels.append(
		[Global.scene_manager.cur_scene_packed, Global.scene().stars]
	)
	var next_level = Global.scene().next_level
	if next_level:
		Global.change_scene(next_level)
	else:
		Global.change_scene(load('res://scenes/ui/level_selection.tscn'))

#func touched_flood(area: Area2D) -> void:
	#if died:
		#return
	#died = true
	#print("DIED")
	#Global.died.emit()


func wall_jumped(body: Node2D) -> void:
	pass
