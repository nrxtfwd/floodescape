extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Global.scene().stars += 1
	var collected = $collected
	collected.emitting = true
	collected.reparent(Global.scene())
	collected.finished.connect(
		func():
			collected.queue_free()
	)
	queue_free()
