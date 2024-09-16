class_name settings_menu
extends Control
func _on_back_pressed() -> void:
	self.hide()
	$"../MainMenu".show()
func _on_fullscreen_toggled(button_pressed) -> void:
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
