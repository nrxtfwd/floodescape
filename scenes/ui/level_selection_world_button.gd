extends PanelContainer

@export var world_name : String = 'Facility'
@export var button_texture : Texture2D
@export var sel_arrow : TextureRect
@export var stars_required_label : Label
@export var stars_required : int = 9
@export var level_range_start : int = 0
@export var level_range_end : int = 3

func select():
	Global.scene().deselect(self)
	sel_arrow.visible = true

func deselect():
	sel_arrow.visible = false

func stars_update(_stars = 0):
	$stars_required.visible = Global.total_stars < stars_required

func _ready() -> void:
	print(world_name)
	$MarginContainer/button.text = world_name
	$background.texture = button_texture
	stars_required_label.text = str(stars_required)
	sel_arrow.visible = false
	stars_update()
	Global.total_stars_changed.connect(stars_update)
	await get_tree().create_timer(0.1).timeout
	sel_arrow.position.x = $background.size.x * (32.0/121.0)

func _on_button_pressed() -> void:
	select()
