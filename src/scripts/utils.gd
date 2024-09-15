extends Node

static func get_random_value(range_value: float) -> float:
	return randf_range(-range_value, range_value)

static func float_to_speed(value: float) -> String:
	return "%0.1f" % value

static func get_speed_color(speed: float, MAX_SPEED: float) -> Color:
	var t = speed / MAX_SPEED
	return Color(1, 1 - t, 1 - t)
