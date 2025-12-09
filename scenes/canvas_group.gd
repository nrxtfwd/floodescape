extends CanvasGroup

var viewport_size: Vector2i



func _ready() -> void:

	viewport_size = get_viewport().size



func _process(_delta: float) -> void:

	var normalized_pos = global_position / Vector2(viewport_size)

	self.material.set_shader_parameter("rotation_pivot", normalized_pos)
