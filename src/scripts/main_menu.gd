class_name main_menu
extends Control
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
func _on_help_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/help_menu.tscn")
func _on_exit_pressed() -> void:
	get_tree().quit()
