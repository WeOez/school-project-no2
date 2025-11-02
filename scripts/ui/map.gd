extends Sprite2D

signal game_started

func _ready() -> void:
	self.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1)
	tween.tween_callback(start_game)

func start_game():
	game_started.emit()
