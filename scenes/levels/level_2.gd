extends Level

@onready var flood =  $flood

func _ready() -> void:
	super()
	flood.velocity = Vector2.ZERO
	await get_tree().create_timer(8.0).timeout
	flood.velocity = flood.normal_velocity
