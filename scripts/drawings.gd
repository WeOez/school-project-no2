extends Node2D

@export var options: Array[Button]
@export var main_toggle: Button
@export var arrow: Sprite2D
@export var button_text: Label

var id: int
var target_pos: Vector2
var x_offset: float
const y_offset = 90.0
var target_positions: Dictionary
var mouse_overlaps_option: bool
var starting_pos: Vector2
var original_rotation: float


signal option_picked(id: int)

func _ready() -> void:
	main_toggle.pressed.connect(_show_options)
	for option in options:
		option.modulate = Color(1.0, 1.0, 1.0, 0.0)
		option.position = main_toggle.position + Vector2(main_toggle.size.x / 2 - options[id].size.x / 2, main_toggle.size.y / 2 - options[id].size.y / 2)
		option.pressed.connect(_option_picked.bind(option))
		option.mouse_entered.connect(_on_mouse_entered_option)
		option.mouse_exited.connect(_on_mouse_exited_option)
		starting_pos = option.position
		
	get_option_data()
	
	original_rotation = get_parent().rotation_degrees
	get_parent().correct_drawing_picked.connect(_erase_from_screen)
	
func _erase_from_screen(_id):
	for option in options:
		var modulater_reverse = create_tween()
		var mover = create_tween()
		mover.tween_property(option, "position", starting_pos, 0.2)
		modulater_reverse.tween_property(option, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2).set_ease(Tween.EASE_IN)
		modulater_reverse.tween_property(main_toggle, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2).set_ease(Tween.EASE_IN)
		option.mouse_filter = Control.MOUSE_FILTER_IGNORE
		main_toggle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed() and not mouse_overlaps_option:
			for option in options:
				var modulater_reverse = create_tween()
				var mover = create_tween()
				mover.tween_property(option, "position", starting_pos, 0.2)
				modulater_reverse.tween_property(option, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2).set_ease(Tween.EASE_IN)
				option.mouse_filter = Control.MOUSE_FILTER_IGNORE

func get_option_data():
	for option in options:
		id = option.get_index() - 1
		
		match id:
			0: # Задаём позицию ровно по центру кнопки
				x_offset = -250.0
				target_pos = options[id].position + Vector2(x_offset, y_offset)
				target_positions.set(id, target_pos)
			1:
				x_offset = -125.0
				target_pos = options[id].position + Vector2(x_offset, y_offset)
				target_positions.set(id, target_pos)
			2:
				x_offset = 0.0
				target_pos = options[id].position + Vector2(x_offset, y_offset)
				target_positions.set(id, target_pos)
			3:
				x_offset = 125.0
				target_pos = options[id].position + Vector2(x_offset, y_offset)
				target_positions.set(id, target_pos)
			4:
				x_offset = 250.0
				target_pos = options[id].position + Vector2(x_offset, y_offset)
				target_positions.set(id, target_pos)

func _show_options():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", - original_rotation, 0.1)
	#arrow.rotation_degrees = get_parent().rotation_degrees
	#button_text.rotation_degrees = get_parent().rotation_degrees
	for option in options:
		option.visible = true
		option.mouse_filter = Control.MOUSE_FILTER_PASS
		var modulater = create_tween()
		modulater.tween_property(option, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)
		for option_id in target_positions:
			var mover = create_tween()
			var pos = target_positions[option_id]
			mover.set_parallel()
			mover.tween_property(options[option_id], "position", pos, 0.2)

func _option_picked(option):
	option_picked.emit(option.get_index())

func _on_mouse_entered_option():
	mouse_overlaps_option = true

func _on_mouse_exited_option():
	mouse_overlaps_option = false
