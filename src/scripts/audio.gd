extends TabBar
func _on_master_off_pressed() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
func _on_master_on_pressed() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
func _on_sfx_on_pressed() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 0)
func _on_sfx_off_pressed() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)
