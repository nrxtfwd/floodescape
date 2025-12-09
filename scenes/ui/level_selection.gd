extends CanvasLayer

@export var grid : GridContainer
@export var levels : Array[PackedScene] = []
@export var star_disabled_color : Color
@export var star_enabled_color : Color

func _ready() -> void:
	var i = 0
	grid.get_node('temp').hide()
	for level in levels:
		i += 1
		var temp = grid.get_node('temp').duplicate()
		var button = temp.get_node('Button')
		var stars = button.get_node('stars')
		temp.show()
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
					stars.get_node('star' + str(star_i+1)).modulate = star_enabled_color
