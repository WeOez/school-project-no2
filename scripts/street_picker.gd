extends Node2D

@export var names: Array[Button]
@export var button: Button
@export var button_text: Label
var id: int
@export var correct_id: int
var offset: float
var mouse_overlaps_option = false
var original_rotation: float

signal option_picked(option_id: int, option: Button, picker_id: int, self_button: Button)

func _ready() -> void:
	for i in names:
		i.visible = false
		i.modulate = Color(1.0, 1.0, 1.0, 0.0)
		i.pressed.connect(_on_option_picked.bind(i))
		i.mouse_entered.connect(_on_mouse_entered_option)
		i.mouse_exited.connect(_on_mouse_exited_option)
	original_rotation = self.rotation_degrees
	get_label_data()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed() and not mouse_overlaps_option:
			var tween = create_tween()
			tween.tween_property(self, "rotation_degrees", original_rotation, 0.1)
			button.visible = true
			button_text.visible = true
			
			for i in names:
				i.visible = false
				tween.tween_property(i, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)

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
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 0.0, 0.1)
	button.visible = false
	button_text.visible = false
	for i in names:
		i.visible = true
		tween.tween_property(i, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)
		
func _on_area_entered(area):
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func _on_area_exited(area):
	button.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_option_picked(option):
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", original_rotation, 0.1)
	for i in names:
		i.visible = false
		tween.tween_property(i, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)

	button.visible = true
	button_text.visible = true
	button_text.text = option.text
	
	option_picked.emit(option.get_index(), option, self.get_index(), button)
	
func _on_mouse_entered_option():
	mouse_overlaps_option = true
	
func _on_mouse_exited_option():
	mouse_overlaps_option = false
