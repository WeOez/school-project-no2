extends Label

var mistakes: int = 0
@onready var panel: Panel = $"../TimerPanel"
@onready var exit_game_button: Button = $"../ExitGameButton"

func _ready() -> void:
	for s in SharedObjects.instance.streets:
		s.incorrect_drawing_picked.connect(_timer_on_player_mistake)
	for c in SharedObjects.instance.cells:
		c.player_made_mistake.connect(_timer_on_player_mistake)
		
	SharedObjects.instance.street_manager.mistake.connect(_timer_on_player_mistake)
	
	self.position -= Vector2(0, MainWindow.center_position.y)
	panel.size = self.size * 1.93
	exit_game_button.size = self.size * 2.65
	panel.global_position = self.position - Vector2(panel.size.x / 2, 0)
	exit_game_button.global_position = self.position - Vector2(exit_game_button.size.x / 2, exit_game_button.size.y / 5.9)
	self.modulate = Color(1.0 ,1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1)
	
func _process(delta: float) -> void:
	self.text = "Таймер: " + str(AttemptsCounter.elapsed_time as int) + "\n" + "Ошибок: " + str(mistakes)

func _timer_on_player_mistake(piece):
	mistakes += 1

func _pause_timer():
	set_process(false)
