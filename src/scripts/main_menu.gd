class_name main_menu
extends Control
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
func _on_settings_pressed() -> void:
	$".".hide()
	$"../OptionsMenu".show()
func _on_exit_pressed() -> void:
	get_tree().quit()
