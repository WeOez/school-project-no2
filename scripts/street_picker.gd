extends Node2D

@export var names: Array[Label]
@export var button: Button
var id: int
var offset: float

#а теперь добавим всему анимации

func _ready() -> void:
	var tween = create_tween()
	for i in names:
		i.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		i.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		i.modulate = Color(1.0, 1.0, 1.0, 0.0)
	get_label_data()

func get_label_data():
	for i in names:
		id = i.get_index() - 1
		match id:
			0:
				offset = -92.0
				names[0].position = button.position + Vector2(0, offset)
				names[0].text = "Производственная Улица"
			1:
				offset = -46.0
				names[1].position = button.position + Vector2(0, offset)
				names[1].text = "Улица Воровского"
			2:
				offset = 0.0
				names[2].position = button.position
				names[2].text = "Солнечная Улица"

func _on_pressed():
	button.visible = false
	var tween = create_tween()
	
	for i in names:
		tween.tween_property(i, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)
		#i.visible = true
