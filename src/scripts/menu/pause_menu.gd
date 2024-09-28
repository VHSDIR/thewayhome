extends Control
func _on_exit_pressed() -> void:
	Engine.time_scale = 1
	get_tree().quit()
func _on_main_menu_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
