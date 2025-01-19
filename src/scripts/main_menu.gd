extends Control
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Music.play_music_level()
	Engine.time_scale = 1

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_more_games_pressed() -> void:
	pass

func _on_exit_pressed() -> void:
	get_tree().quit()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape_key"):
		get_tree().quit()
