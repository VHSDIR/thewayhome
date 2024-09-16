class_name win_menu
extends Control
func _on_reset_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
