extends Node2D

@export var streets: Array[Node2D]

func _ready() -> void:
	for c in get_children():
		c.visible = false
		
	for s in streets:
		s.correct_drawing_picked.connect(_on_drawing_picked)
		
func _on_drawing_picked(id):
	get_child(id.get_index()).visible = true
