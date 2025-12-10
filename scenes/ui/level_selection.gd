extends CanvasLayer

@export var grid : GridContainer
@export var levels : Array[PackedScene] = []
@export var star_disabled_color : Color
@export var star_enabled_color : Color
@export var select_first_world_button : PanelContainer
@export var world_name_label : Label

var cur_select

func deselect(new):
	if cur_select:
		cur_select.deselect()
	cur_select = new
	world_name_label.text = new.world_name
	for child in grid.get_children():
		if child.has_meta('level_num'):
			var level_num = child.get_meta('level_num')
			if level_num < new.level_range_start or level_num > new.level_range_end:
				child.hide()
			else:
				child.show()

func _ready() -> void:
	var i = 0
	var total_stars = 0
	grid.get_node('temp').hide()
	for level in levels:
		i += 1
		var temp = grid.get_node('temp').duplicate()
		var button = temp.get_node('Button')
		var stars = button.get_node('stars')
		temp.show()
		temp.set_meta('level_num', i-1)
		button.text = str(i)
		grid.add_child(temp)
		button.pressed.connect(
			func():
				Global.change_scene(level)
		)
		for star in stars.get_children():
			star.modulate = star_disabled_color
		for level_data in Global.completed_levels:
			if level_data[0] == level:
				for star_i in range(level_data[1]):
					total_stars += 1
					stars.get_node('star' + str(star_i+1)).modulate = star_enabled_color
	Global.total_stars = 100#total_stars
	deselect(select_first_world_button)
	select_first_world_button.select()
