extends Node
class_name SharedObjects

static var instance: SharedObjects

@export var cells: Array[Area2D]
@export var pieces: Array[Area2D]
@export var streets: Array[Node2D]
@export var street_manager: Node2D
@export var drawings: Array[Sprite2D]
@export var game_manager: Node2D

func _ready() -> void:
	instance = self
