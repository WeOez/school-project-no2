extends Node2D

@export var names: Array[Button]
@export var button: Button
@export var button_text: Label
@export var arrow: Sprite2D
@export var needs_to_be_different_direction: bool
@export var drawing: Control
@export var option_size: Vector2

var id: int
@export var correct_id: int
var offset: float
var mouse_overlaps_option = false
var original_rotation: float

var picked_options = []
var available_options = []

signal option_picked(option_id: int, option: Button, picker_id: int, self_button: Button, arrow: Sprite2D, drawing: Control)
signal correct_drawing_picked(id: int)
signal incorrect_drawing_picked(id: int)

func _ready() -> void:
	for i in names:
		i.z_index = 1
		i.visible = false
		i.modulate = Color(1.0, 1.0, 1.0, 0.0)
		i.pressed.connect(_on_option_picked.bind(i))
		i.mouse_entered.connect(_on_mouse_entered_option)
		i.mouse_exited.connect(_on_mouse_exited_option)
	original_rotation = self.rotation_degrees
	
	#drawing.rotation_degrees = original_rotation
	#print(drawing.rotation_degrees)
	available_options = Utils.instance._subcrtact_array(names, picked_options)
	
	Utils.instance._set_positions_vertical_list(available_options, {}, button.position, option_size)
	get_label_text()
	
	drawing.visible = false
	#drawing.option_picked.connect(_test)
	drawing.get_child(1).option_picked.connect(_test)
	SharedObjects.instance.street_manager.correct.connect(_on_correct_option_picked)
	
	if needs_to_be_different_direction:
		rotate_arrow()
	
func _test(draw_id):
	match draw_id:
		0, 1, 2, 3, 4, 5, 6, 7:
			if draw_id == self.get_index():
				correct_drawing_picked.emit(self)
			else:
				print(draw_id, " ", self.get_index())
				incorrect_drawing_picked.emit(draw_id)
	
func _on_correct_option_picked(id: int):
	picked_options.append(names[id])
	available_options = Utils.instance._subcrtact_array(names, picked_options)
	Utils.instance._set_positions_vertical_list(available_options, {}, button.position, option_size)
	
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed() and not mouse_overlaps_option:
			var tween = create_tween()
			tween.tween_property(self, "rotation_degrees", original_rotation, 0.1)
			button.visible = true
			button_text.visible = true
			
			for i in available_options:
				i.visible = false
				tween.tween_property(i, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)
	
func get_label_text():
	for i in available_options:
		id = i.get_index() - 1
		match id: 
			0:
				names[id].text = "Производственная Улица"
			1:
				names[id].text = "Улица Воровского"
			2:
				names[id].text = "Солнечная Улица"
			3:
				names[id].text = "Московская Улица"
			4: 
				names[id].text = "Проспект Строителей"
			5:
				names[id].text = "Улица Менделеева"
			6:
				names[id].text = "Улица Екатерины Кочкиной"

func rotate_arrow() -> void:
	arrow.rotation_degrees += 180

func _on_pressed():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 0.0, 0.1)
	button.visible = false
	button_text.visible = false
	for i in available_options:
		i.visible = true
		tween.tween_property(i, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)
		
func _on_area_entered(area):
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func _on_area_exited(area):
	button.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_option_picked(option):
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", original_rotation, 0.1)
	for i in available_options:
		i.visible = false
		tween.tween_property(i, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)

	button.visible = true
	button_text.visible = true
	button_text.text = option.text
	
	option_picked.emit(option.get_index(), option, self.get_index(), button, arrow, drawing)
	
func _on_mouse_entered_option():
	mouse_overlaps_option = true
	
func _on_mouse_exited_option():
	mouse_overlaps_option = false
