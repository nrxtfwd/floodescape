extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var camera : Camera2D

@onready var anim_player = $AnimationPlayer
@onready var walk_particles = $walk_particles

var last_jumped = 0
var died = false
var was_underwater = false
var last_on_floor = -100.0
var on_ladder = false
var water_jump = false
var got_on_ladder = 0

func _ready() -> void:
	Global.player = self

func _physics_process(delta: float) -> void:
	if died:
		return
	
	var tick = Global.tick()
	var is_underwater = len($water.get_overlapping_areas()) > 0
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		last_on_floor = tick
		water_jump = false
	
	var can_jump = Input.is_action_pressed("jump") and tick - last_on_floor <= 0.23 and tick - last_jumped > 0.45
	if can_jump or (was_underwater and !is_underwater):
		velocity.y = JUMP_VELOCITY
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
		if !can_jump:
			var flip_dir = sign(velocity.x)
			if flip_dir != 0:
				water_jump = flip_dir
	
	#if water_jump:
		#rotation += (1.0/360.0) * 2.0 * PI * 3.0 * sign(velocity.x)
	
	var direction := Input.get_axis("left", "right")
	if !is_underwater:
		rotation = 0
		if on_ladder:
			velocity.y = Input.get_axis('up', 'down') * SPEED
		if !on_ladder or (tick - got_on_ladder) > 0.3:
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		var swim_dir = Input.get_vector('left', 'right', 'up', 'down') * SPEED
		velocity = velocity.move_toward(swim_dir, SPEED * 0.2)
		look_at(global_position + velocity)
		rotation += PI /2.0
	$swim.emitting = is_underwater
	
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
