extends HBoxContainer

var mouse_overlaps_option: bool
var options = []
var original_rotation: float

@export var toggle: Button
@export var option_size: Vector2

signal option_picked(id: int)

func _ready() -> void:
	toggle.pressed.connect(_change_visibility)
	for option in get_children():
		option.custom_minimum_size = option_size
		option.modulate = Color(1.0, 1.0, 1.0, 0.0)
		options.append(option)
		
		#Все сигналы коннектить здесь
		option.pressed.connect(_pick_option.bind(option.get_index()))
		option.mouse_entered.connect(_on_mouse_entered_option)
		option.mouse_exited.connect(_on_mouse_exited_option)
		
	original_rotation = get_parent().get_parent().rotation_degrees
	
	for s in SharedObjects.instance.streets:
		s.correct_drawing_picked.connect(_on_correct_drawing_picked)
	
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed() and not mouse_overlaps_option:
			var tween = create_tween()
			var toggle_tween = create_tween()
			for o in options:
				if o != null:
					tween.set_parallel()
					tween.tween_property(o, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.25).set_ease(Tween.EASE_IN)
					o.mouse_filter = Control.MOUSE_FILTER_IGNORE
			toggle_tween.tween_property(toggle, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.29).set_ease(Tween.EASE_IN)
			toggle_tween.tween_callback(util_shi.bind(true, toggle))
			
func _change_visibility():
	var tween = create_tween()
	tween.tween_property(toggle, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.25).set_ease(Tween.EASE_IN)
	tween.tween_property(get_parent(), "rotation_degrees", -original_rotation, 0.1)
	tween.tween_callback(util_shi.bind(false, toggle))
	for o in options:
		if o != null:
			o.mouse_filter = Control.MOUSE_FILTER_STOP
			tween.set_parallel()
			tween.tween_property(o, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.25).set_ease(Tween.EASE_IN)
			o.visible = true
		
func _erase_from_screen():
	var tween = create_tween()
	var toggle_tween = create_tween()
	for o in options:
		if o != null:
			tween.set_parallel()
			tween.tween_property(o, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.25).set_ease(Tween.EASE_IN)
			o.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
func _on_correct_drawing_picked(street):
	_erase_from_screen()
	var id = street.get_index()
	options[id].queue_free()
		
func util_shi(visible: bool, object):
	object.visible = visible

func _pick_option(id: int):
	option_picked.emit(id)
	
func _on_mouse_entered_option():
	mouse_overlaps_option = true

func _on_mouse_exited_option():
	mouse_overlaps_option = false
