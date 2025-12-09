extends Label

func stars_changed(stars):
	text = str(stars) + '/3 Stars'

func _ready() -> void:
	stars_changed(0)
	Global.scene_changed.connect(stars_changed.bind(0))
	Global.stars_changed.connect(stars_changed)
