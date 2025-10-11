extends Node2D
class_name GameFinisher

var correct_pieces = []
var mistake_pieces = []

var starting_modulate = Color(1.0, 1.0, 1.0, 0.0)
var target_modulate = Color(1.0, 1.0, 1.0, 1.0)

@export var finishing_amount: int
@export var max_mistakes_amount: int
@export var max_points: int
@export var attempts_count_penalty_multiplier: int
@export var minimal_time_for_penalty: int

#Импорт штук для экранов поражения и победы
@onready var color_rect: ColorRect = $"../BackGroundDimmer"
@onready var win: Label = $"../win"
@onready var loss: Label = $"../loss"
@onready var stats: Label = $"../stats"
@onready var timer: Label = $"../Timer"
@onready var exit_game_button: Button = $"../ExitGameButton"
@onready var timer_panel: Panel = $"../TimerPanel"
#Импорт звуков
@onready var correct_piece_placement: AudioStreamPlayer2D = $"../Sounds/CorrectPiecePlacement"
@onready var piece_placed_incorrectly: AudioStreamPlayer2D = $"../Sounds/PiecePlacedIncorrectly"
@onready var win_sound: AudioStreamPlayer2D = $"../Sounds/Win"
@onready var lose_sound: AudioStreamPlayer2D = $"../Sounds/Lose"

@onready var testing: Label = $"../testing"

signal player_lost

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
	
	loss.visible = false
	loss.modulate = starting_modulate
	loss.position += Vector2(0, -100)
	loss.z_index = 4
	
	stats.visible = false
	stats.modulate = starting_modulate
	stats.position += Vector2(0, 150)
	stats.z_index = 4
	
	exit_game_button.modulate = starting_modulate
	timer_panel.modulate = target_modulate
	
func _process(delta: float) -> void:
	if correct_pieces.size() == finishing_amount:
		color_rect.visible = true
		win.visible = true
		stats.visible = true
		var tween = create_tween()
		var tween_sound = create_tween()
		tween.tween_property(timer, "modulate", starting_modulate, 0.5)
		tween.tween_property(exit_game_button, "modulate", target_modulate, 0.4)
		win_sound.play()
		tween_sound.tween_property(win_sound, "volume_db", -60.0, 7.0)
		tween_sound.tween_callback(_reset_sound_volume.bind(0.0, win_sound))
		tween.tween_property(color_rect, "modulate", target_modulate, 0.5)
		tween.tween_property(win, "modulate", target_modulate, 0.5)
		tween.tween_property(stats, "modulate", target_modulate, 0.5)
		stats.text = "Количество ошибок: " + str(mistake_pieces.size()) + "\n" + "Потраченное время: " + str(AttemptsCounter.elapsed_time as int) + " секунд\n" + "Заработанные очки: " + str(count_points()) + "\n"
		set_process(false)
	#тут был код поражения
	
func count_points() -> int:
	var points: int = 0
	
	var mistakes_penalty = attempts_count_penalty_multiplier * mistake_pieces.size()
	var time_penalty = AttemptsCounter.elapsed_time as int / minimal_time_for_penalty
	
	points = max_points - mistakes_penalty - time_penalty
	return points
	
func continue_game():
	get_tree().quit(0) #Сделать переключение на следующую игру // ха, игры от не будет
	
func reload_scene():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/first_map_game.tscn")
