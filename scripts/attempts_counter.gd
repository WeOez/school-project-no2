extends Node

var attempts: int = 1 #Начинаем счёт попыток с 1, потому что с 0 как-то странно
var elapsed_time: float = 0.0

var is_paused

func _process(delta: float) -> void:
	elapsed_time += delta
	
	if is_paused:
		set_process(false)
	elif not is_paused:
		set_process(true)
		
func _pause_timer():
	set_process(false)
	
func _unpause_timer():
	is_paused = false
