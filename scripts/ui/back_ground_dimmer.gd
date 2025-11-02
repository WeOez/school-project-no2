extends ColorRect

func _ready() -> void:
	self.size = MainWindow.viewport_size + Vector2(100, 100)
