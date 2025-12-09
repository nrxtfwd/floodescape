extends Label

func level_changed(level_id):
	text = 'Level ' + level_id

func _ready() -> void:
	Global.level_changed.connect(level_changed)
