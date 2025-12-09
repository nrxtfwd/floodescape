extends Area2D

@onready var sprite = $Sprite2D

var normal_velocity = Vector2(0,-0.2)

@export var velocity = Vector2.ZERO
@export var start_delay = 0.01

func _ready() -> void:
	sprite.material.set_shader_parameter('wave_frequency', 13.0 + scale.x * 0.5)
	if start_delay > 0.2:
		await get_tree().create_timer(start_delay).timeout
		velocity = normal_velocity

func _physics_process(delta: float) -> void:
	global_position += velocity
