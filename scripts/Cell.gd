extends Area2D
class_name Cell

var occupied_positions = []
var incorrect_cells = [] #для возврата мешей
@export var mesh: MeshInstance2D
@export var label: Label

signal piece_placed_correctly(piece)
signal player_made_mistake(piece)

func _ready() -> void:
	#Делаем FadeIn эффект
	self.modulate = Color(1.0, 1.0, 1.0, 0.0)
	mesh.modulate = Color(1.0, 1.0, 1.0, 0.0)
	label.modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	var tween = create_tween()
	var mesh_tween = create_tween()
	var label_tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1)
	mesh_tween.tween_property(mesh, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1)
	label_tween.tween_property(label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1).set_ease(Tween.EASE_OUT_IN)

func _on_piece_entered(piece):
	#Отвечает за постановку зданий и за то, чтобы нельзя было поставить сразу несколько в одну ячейку
	if self.global_position.distance_to(piece.global_position) < 65 and not self.get_index() in occupied_positions and not piece.is_returning and not piece.is_dragging and not piece.is_placed:
		occupied_positions.append(self.get_index())
		var tween = create_tween()
		tween.tween_property(piece, "global_position", self.global_position, 0.1).set_ease(Tween.EASE_OUT_IN)
		piece.is_draggable = false
		piece.z_index = 0
		tween.tween_property(piece, "rotation_degrees", 0.0, 0.5)
		check_piece(piece)

func handle_recreation(piece: Variant) -> void:
	var button_tween = create_tween()
	piece.is_draggable = true
	piece.scale = Vector2(1.5, 1.5)
	piece.remove_from_cell_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button_tween.tween_property(piece.remove_from_cell_button, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
	occupied_positions.erase(self.get_index())
	if self.get_index() in incorrect_cells:
		var tween = create_tween()
		tween.tween_property(mesh, "scale", Vector2(100, 100), 0.2).set_ease(Tween.EASE_OUT_IN)

func check_piece(piece):
	match piece.id:
		1,2,3,4,5,6,7,8,9,10,11:
			if piece.correct_cell_id == self.get_index() and self.global_position.distance_to(piece.global_position) < 65:
				var tween = create_tween()
				piece.is_placed = true
				piece.scale_image_down(self.scale.x, self.scale.y)
				tween.tween_property(mesh, "scale", Vector2(0,0), 0.2).set_ease(Tween.EASE_IN_OUT)
				tween.tween_property(label, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.1)
				tween.tween_property(piece.remove_from_cell_button, "modulate", Color(0.443, 0.506, 0.204, 1), 0.2)
				piece.z_index = 1
				piece_placed_correctly.emit(piece)
			else:
				if not piece.is_returning and not piece.is_on_starting_pos:
					#print(str(piece.correct_cell_id + 1) + " " + str(self.get_index()))
					var tween = create_tween()
					piece.is_placed = false
					piece.remove_from_cell_button.mouse_filter = Control.MOUSE_FILTER_PASS
					if not incorrect_cells.has(self.get_index()):
						incorrect_cells.append(self.get_index())
					piece.add_to_group("incorrectly_placed_pieces")
					tween.tween_property(piece.remove_from_cell_button, "modulate", Color.RED, 0.2)
					player_made_mistake.emit(piece)
