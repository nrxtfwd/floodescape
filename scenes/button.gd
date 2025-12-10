extends Area2D

@export var object : Node2D
@export var switched_on : Color
@export var inverted = false

var activated = false

func _ready() -> void:
	if inverted:
		object.modulate = Color(1,1,1,0.5)
		object.get_node('col_shape').set_deferred('disabled', true)

func _on_body_entered(body: Node2D) -> void:
	if activated:
		return
	activated = true
	modulate = switched_on
	
	var tween = get_tree().create_tween()
	tween.tween_property($lever, 'rotation', PI/4.0, 0.5)
	
	if inverted:
		object.modulate = Color.WHITE
		object.get_node('col_shape').set_deferred('disabled', false)
	else:
		object.queue_free()
