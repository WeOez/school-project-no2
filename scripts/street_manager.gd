extends Node2D
@export var options: Array[Node2D]

signal correct(street)
signal mistake(street)

func _ready() -> void:
	self.visible = false
	for i in options:
		i.option_picked.connect(check)
		
func check(id: int, option: Button, picker_id: int, self_button: Button, arrow: Sprite2D, drawing: Node2D):
	match id:
		1, 2, 3, 4, 5:
			var index = id - 1
			if index == picker_id:
				var tween = create_tween()
				tween.tween_property(arrow, "modulate", Color(0.443, 0.506, 0.204, 1), 0.2)
				self_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
				drawing.visible = true
				correct.emit(id)
			else:
				var tween = create_tween()
				tween.tween_property(arrow, "modulate", Color.RED, 0.2)
				mistake.emit(id)

func _on_game_switched():
	self.set_deferred("visible", true)
