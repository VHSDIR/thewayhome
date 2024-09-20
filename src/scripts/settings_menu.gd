extends Control
func _ready() -> void:
	Engine.time_scale = 1
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
func _on_fullscreen_pressed() -> void:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
func _on_maximized_pressed() -> void:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
