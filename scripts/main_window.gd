extends Control

var viewport_size: Vector2
var center_position: Vector2

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	
	center_position = viewport_size / 2
	
	self.position = center_position
	if viewport_size > Vector2(1920, 1080):
		self.scale = Vector2(1.3, 1.3)
