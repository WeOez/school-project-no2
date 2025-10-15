extends Node2D
class_name GameFinisher

var correct_pieces = []
var mistake_pieces = []

var is_game_switched = false
var starting_modulate = Color(1.0, 1.0, 1.0, 0.0)
var target_modulate = Color(1.0, 1.0, 1.0, 1.0)

@export var finishing_amount: int
@export var streets_finishing_amount: int
@export var max_mistakes_amount: int
@export var max_points: int
@export var attempts_count_penalty_multiplier: int
@export var minimal_time_for_penalty: int
@export var start_from_second_game: bool

#Импорт штук для экранов поражения и победы
@onready var color_rect: ColorRect = $"../BackGroundDimmer"
@onready var win: Label = $"../win"
@onready var stats: Label = $"../stats"
@onready var timer: Label = $"../Timer"
@onready var exit_game_button: Button = $"../ExitGameButton"
@onready var timer_panel: Panel = $"../TimerPanel"
@onready var continue_button: Button = $Continue

#Импорт звуков
@onready var correct_piece_placement: AudioStreamPlayer2D = $"../Sounds/CorrectPiecePlacement"
@onready var piece_placed_incorrectly: AudioStreamPlayer2D = $"../Sounds/PiecePlacedIncorrectly"
@onready var win_sound: AudioStreamPlayer2D = $"../Sounds/Win"

signal player_lost
signal switch_game

func _reset_sound_volume(volume: float, sound: AudioStreamPlayer2D):
	sound.volume_db = volume

func accept_cell(piece):
	if not correct_pieces.has(piece):
		correct_pieces.append(piece)
		correct_piece_placement.play()
		var tween = create_tween()
		tween.tween_property(correct_piece_placement, "volume_db", -60.0, 0.8)
		tween.tween_callback(_reset_sound_volume.bind(0.0, correct_piece_placement))
	
func accept_mistake(piece):
	mistake_pieces.append(piece)
	piece_placed_incorrectly.play()
	var tween = create_tween()
	tween.tween_property(piece_placed_incorrectly, "volume_db", -60.0, 1.5)
	tween.tween_callback(_reset_sound_volume.bind(0.0, piece_placed_incorrectly))

func _ready() -> void:
	color_rect.visible = false
	color_rect.modulate = starting_modulate
	color_rect.z_index = 3
	
	win.visible = false
	win.modulate = starting_modulate
	win.position += Vector2(0, -100)
	win.z_index = 4
	
	stats.visible = false
	stats.modulate = starting_modulate
	stats.position += Vector2(0, 150)
	stats.z_index = 4
	
	exit_game_button.modulate = starting_modulate
	timer_panel.modulate = target_modulate
	
	continue_button.visible = false
	continue_button.modulate = starting_modulate
	continue_button.position.y += 150
	
	if start_from_second_game:
		correct_pieces.resize(10)
	
func _process(delta: float) -> void:
	if correct_pieces.size() == finishing_amount and not is_game_switched:
		color_rect.visible = true
		win.text = "Вы прошли 1 этап!"
		win.visible = true
		continue_button.visible = true
		var tween = create_tween()
		tween.tween_property(timer, "modulate", starting_modulate, 0.5)
		tween.tween_property(color_rect, "modulate", target_modulate, 0.5)
		tween.tween_property(win, "modulate", target_modulate, 0.5)
		tween.tween_property(continue_button, "modulate", target_modulate, 0.5)
	
	if correct_pieces.size() == streets_finishing_amount + finishing_amount and is_game_switched:
		color_rect.visible = true
		win.text = "Победа!"
		win.visible = true
		stats.visible = true
		var tween = create_tween()
		var tween_sound = create_tween()
		tween.tween_property(timer, "modulate", starting_modulate, 0.5)
		
		win_sound.play()
		tween_sound.tween_property(win_sound, "volume_db", -60.0, 7.0)
		tween_sound.tween_callback(_reset_sound_volume.bind(0.0, win_sound))
		
		tween.tween_property(color_rect, "modulate", target_modulate, 0.5)
		tween.tween_property(win, "modulate", target_modulate, 0.5)
		tween.tween_property(exit_game_button, "modulate", target_modulate, 0.4)
		tween.tween_property(stats, "modulate", target_modulate, 0.5)
		
		stats.text = "Количество ошибок: " + str(mistake_pieces.size()) + "\n" + "Потраченное время: " + str(AttemptsCounter.elapsed_time as int) + " секунд\n" + "Заработанные очки: " + str(count_points()) + "\n"
		
		set_process(false)
	else:
		pass
		#print(correct_pieces.size())
		
func _on_button_press():
	is_game_switched = true
	color_rect.visible = false
	win.visible = false
	var tween = create_tween()
	tween.tween_property(timer, "modulate", target_modulate, 0.5)
	tween.tween_property(color_rect, "modulate", starting_modulate, 0.5)
	tween.tween_property(win, "modulate", starting_modulate, 0.5)
	tween.tween_property(continue_button, "modulate", starting_modulate, 0.5)
	continue_button.visible = false
	switch_game.emit()
	
func count_points() -> int:
	var points: int = 0
	
	var mistakes_penalty = attempts_count_penalty_multiplier * mistake_pieces.size()
	var time_penalty = AttemptsCounter.elapsed_time as int / minimal_time_for_penalty #поменять, либо убрать вообще
	
	points = max_points - mistakes_penalty - time_penalty
	return points
	
func _exit():
	get_tree().quit(0)
