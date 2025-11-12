extends Node
class_name Utils

static var instance: Utils

func _ready() -> void:
	instance = self

func _subcrtact_array(substractable_array: Array, substracting_array: Array) -> Array:
	var result = substractable_array.duplicate()
	
	for item in substracting_array:
		result.erase(item)
		
	return result

func _set_positions_vertical_list(items_array: Array, positions_dictionary: Dictionary, center_position: Vector2, item_size: Vector2):
	var max_negative_offset
	var max_positive_offset
	var offset
	
	if items_array != []:
		max_negative_offset = items_array.size() / 2 * -item_size.y
		max_positive_offset = items_array.size() / 2 * item_size.y
		
		for index in items_array.size():
			offset = max_negative_offset + (item_size.y * index)
			items_array[index].position = center_position + Vector2(0, offset)
			
			if positions_dictionary != null:
				positions_dictionary.set(index, Vector2(0, offset))
