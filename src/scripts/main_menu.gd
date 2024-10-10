extends Control
func _ready() -> void:
	Music.play_music_level()
	Engine.time_scale = 1
func _on_play_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/main.tscn")
func _on_settings_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")
func _on_exit_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().quit()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _on_credits_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/help_menu.tscn")
