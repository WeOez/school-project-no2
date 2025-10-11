extends Area2D
class_name PuzzlePiece

#Состояния объекта
var mouse_overlap = false
var is_dragging = false
var is_draggable = true
var is_placed = false
var is_returning = false #Из-за бага при возвращении объекта нужна эта тема, не убирать и не изменять начальное состояние
var is_on_starting_pos = true

signal remove_from_cell(piece)
signal placed_in_cell(piece)

var drag_state: int
var texture_scale: Vector2
var id: int
var correct_cell_id: int

@onready var piece_picked: AudioStreamPlayer2D = $"../../../Sounds/PiecePicked"

@export var Tex: Sprite2D
@export var Textures: Array[Sprite2D]
@export var remove_from_cell_button: Button
#Списки для нормального возвращения объектов в начальные положения
var piece_positions = []
var occupied_positions = []
var mistake_pieces = []
var picked_pieces = []

func _ready() -> void:
	#Делаем FadeIn эффект
	self.modulate = Color(1.0, 1.0, 1.0, 0.0)
	#self.scale = Vector2(1.5,1.5)
	self.z_index = 1
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1)
	
	#Добавляем начальные позиции объектов
	piece_positions.append(self.position)
	occupied_positions.append(piece_positions)
	
	remove_from_cell_button.mouse_filter = Control.MOUSE_FILTER_STOP
	remove_from_cell_button.modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	for i in Textures.size():
		Textures[i].visible = false
		Textures[i].z_index = 1
	
	assign_id()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed() and mouse_overlap and is_draggable and not is_dragging:
			is_dragging = true
			z_index = 2
			scale_image_up(1.25, 1.25)
			var tween = create_tween()
			tween.tween_property(remove_from_cell_button, "modulate", Color(1.0 ,1.0, 1.0, 0.0), 0.2)
			occupied_positions.erase(piece_positions)
		elif not event.is_pressed():
			is_dragging = false
			placed_in_cell.emit(self)
			if not is_placed:
				scale_image_down(1.0, 1.0)
			place_piece_back()
	if event is InputEventScreenDrag and mouse_overlap and is_draggable and not is_placed and is_dragging:
		var movement_direction = event.relative
		var tween = create_tween()
		if movement_direction.x > 0:
			drag_state = 0
		elif movement_direction.x < 0:
			drag_state = 1
		else: drag_state = 2
		rotate_piece(tween)

func place_piece_back():
	if not is_on_starting_pos and is_draggable:
		var tween = create_tween()
		tween.tween_property(self, "position", piece_positions[0], 0.35).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "rotation_degrees", 0.0, 0.2)
		remove_from_cell_button.mouse_filter = Control.MOUSE_FILTER_STOP
		is_on_starting_pos = true

func player_lost_handler():
	if not piece_positions in occupied_positions:
		self.set_deferred("monitorable", false) #Чтобы оно не реагировало во время перемещения
		var tween = create_tween()
		tween.tween_property(self, "position", piece_positions[0], 0.35).set_ease(Tween.EASE_IN_OUT)
		remove_from_cell_button.modulate = Color(1.0, 1.0, 1.0, 0.0)
		
#Из-за бага при возвращении объекта нужна эта тема
func restore_piece():
	is_returning = false
	self.remove_from_group("incorrectly_placed_pieces")
	remove_from_cell_button.mouse_filter = Control.MOUSE_FILTER_STOP
	is_on_starting_pos = true
	z_index = 1
	
func assign_id():
	match self.position:
		Vector2(-654, 27):
			id = 1 #52 школа
			correct_cell_id = 0
			Textures[0].visible = true
			Textures[0].scale = Vector2(0.03, 0.03)
			texture_scale = Textures[0].scale
		Vector2(-654, 146):
			id = 2 #Сцена в КП
			correct_cell_id = 1
			Textures[2].visible = true
			Textures[2].scale = Vector2(0.06,0.06)
			texture_scale = Textures[2].scale
		Vector2(-654, 266):
			id = 3 #Церковь
			correct_cell_id = 2
			Textures[1].visible = true
			Textures[1].scale = Vector2(0.04,0.04)
			Textures[1].offset = Vector2(184, -312)
			texture_scale = Textures[1].scale
		Vector2(-654, 386):
			id = 4 #ТРЦ Фестиваль
			correct_cell_id = 3
			Textures[3].visible = true
			Textures[3].scale = Vector2(0.05,0.05)
			texture_scale = Textures[3].scale
		Vector2(615, 386):
			id = 5 #27 школа
			correct_cell_id = 4
			Textures[4].visible = true
			Textures[4].scale = Vector2(0.2,0.2)
			texture_scale = Textures[4].scale
		Vector2(615, 266):
			id = 6 #ДОСААФ
			correct_cell_id = 5
			Textures[5].visible = true
			Textures[5].scale = Vector2(0.05,0.05)
			texture_scale = Textures[5].scale
		Vector2(615, 146):
			id = 7 #ТРЦ Глобус
			correct_cell_id = 6
			Textures[6].visible = true
			Textures[6].scale = Vector2(0.1,0.1)
			texture_scale = Textures[6].scale
		Vector2(615, 27):
			id = 8 #СШОР 1, РИО с нами больше нет, R.I.P
			correct_cell_id = 7
			Textures[10].visible = true
			Textures[10].scale = Vector2(0.28,0.28)
			texture_scale = Textures[7].scale
		Vector2(615, -91):
			id = 9 #Памятник Коневу
			correct_cell_id = 8
			Textures[8].visible = true
			Textures[8].scale = Vector2(0.04,0.04)
			Textures[8].offset = Vector2(0, -850)
			texture_scale = Textures[8].scale
		Vector2(-654, -91):
			id = 10 #Быстрица
			correct_cell_id = 9
			Textures[9].visible = true
			Textures[9].scale = Vector2(0.07, 0.07)

func rotate_piece(tween: Tween):
	match drag_state:
		0:
			tween.tween_property(self, "rotation_degrees", 30.0, 0.5)
		1:
			tween.tween_property(self, "rotation_degrees", -30.0, 0.5)
		2:
			tween.tween_property(self, "rotation_degrees", 0, 0.5)

func _process(_delta: float) -> void:
	if is_dragging and mouse_overlap:
		global_position = get_viewport().get_mouse_position()
		is_on_starting_pos = false
		
func scale_image_up(x: float, y: float):
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2(x, y), 0.1).set_ease(Tween.EASE_OUT_IN)
	
func scale_image_down(x: float, y: float):
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2(x, y), 0.15).set_ease(Tween.EASE_OUT_IN)
	
func _on_area_2d_mouse_entered():
	mouse_overlap = true
		
func _reset_sound_volume(volume: float, sound: AudioStreamPlayer2D):
	sound.volume_db = volume
		
func _on_pressed_remove_from_cell():
	if not is_placed and not is_draggable and not is_on_starting_pos:
		is_returning = true #Из-за бага при возвращении объекта нужна эта тема
		remove_from_cell.emit(self)
		var tween = create_tween()
		tween.tween_property(self, "position", piece_positions[0], 0.35).set_ease(Tween.EASE_IN_OUT)
		tween.tween_callback(restore_piece) #Из-за бага при возвращении объекта нужна эта тема
	elif is_on_starting_pos:
		var tween = create_tween()
		var sound_tween = create_tween()
		piece_picked.play()
		sound_tween.tween_property(piece_picked, "volume_db", -60.0, 0.15)
		sound_tween.tween_callback(_reset_sound_volume.bind(0.0, piece_picked))
		tween.tween_property(remove_from_cell_button, "modulate", Color.WHITE_SMOKE, 0.2)
		remove_from_cell_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func _on_area_2d_mouse_exited():
	mouse_overlap = false

func _on_other_piece_entered(piece):
	if not is_placed and not is_draggable or is_on_starting_pos:
		remove_from_cell_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func _on_other_piece_exited(piece):
	if not is_placed and not is_draggable or is_on_starting_pos:
		remove_from_cell_button.mouse_filter = Control.MOUSE_FILTER_STOP
#Получается оно там уже отпустило второй объект, а потом при нажатии он типа обновился и засчитал ошибку
