extends ProgressBar

var tween : Tween
var connected = []

func oxygen_changed(oxygen):
	tween = get_tree().create_tween()
	tween.tween_property(self, 'value', oxygen, 0.1)

func _process(delta: float) -> void:
	#if !Global.player:
		#return
	#visible = Global.player.is_underwater
	pass

func scene_changed():
	if Global.player:
		oxygen_changed(1.0)
		if connected.find(Global.player) == -1:
			Global.player.oxygen_changed.connect(oxygen_changed)
			connected.append(Global.player)
		

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	scene_changed()
	Global.scene_changed.connect(scene_changed)

func _on_visibility_changed() -> void:
	if Global.player:
		oxygen_changed(Global.player.oxygen/100.0)
