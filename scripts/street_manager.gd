extends Node2D
@export var options: Array[Node2D]

signal correct(street)
signal mistake(street)

func _ready() -> void:
	self.global_position.y += MainWindow.viewport_size.y
	for i in options:
		i.option_picked.connect(check)
		
func check(id: int, option: Button, picker_id: int, self_button: Button):
	match id:
		1, 2, 3:
			var index = id - 1
			if index == picker_id:
				var tween = create_tween()
				tween.tween_property(self_button, "modulate", Color(0.443, 0.506, 0.204, 1), 0.2)
				self_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
				correct.emit(id)
			else:
				var tween = create_tween()
				tween.tween_property(self_button, "modulate", Color.RED, 0.2)
				mistake.emit(id)

func _on_game_switched():
	self.global_position.y -= MainWindow.viewport_size.y
