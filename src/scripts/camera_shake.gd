extends Camera3D
var shake_factor: float = 0.0
var max_shake_intensity: float = 0.1
var shake_decay: float = 0.1
var original_position: Vector3
var original_rotation: Vector3
func _ready():
	original_position = position
	original_rotation = rotation
func _process(_delta: float):
	if shake_factor > 0:
		var actual_intensity = shake_factor * max_shake_intensity
		rotation = original_rotation + Vector3(
			randf_range(-actual_intensity, actual_intensity) * 0.05,
			randf_range(-actual_intensity, actual_intensity) * 0.05,
			randf_range(-actual_intensity, actual_intensity) * 0.05
		)
	else:
		position = original_position
		rotation = original_rotation
func randf_range(valuemin: float, valuemax: float) -> float:
	return randf() * (valuemax - valuemin) + valuemin
func set_shake_factor(new_factor: float):
	shake_factor = clamp(new_factor, 0.0, 1.0)
