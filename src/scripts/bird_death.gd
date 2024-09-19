extends Control
func _on_reset_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
