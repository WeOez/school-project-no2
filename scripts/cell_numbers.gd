extends Label

func _ready() -> void:
	
	self.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	self.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	self.set("theme_override_colors/font_color", Color.BLACK)
	self.set("theme_override_font_sizes/font_size", 80)
	self.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.8))
	self.add_theme_constant_override("shadow_outline_size", 8)
	
	self.text = str(get_parent().get_index() + 1);
