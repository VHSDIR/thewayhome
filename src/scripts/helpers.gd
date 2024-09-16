class_name utils
extends Node
static var randomNumberGenerator = RandomNumberGenerator.new()

static func float_to_speed(value: float) -> String:
	return "%0.1f" % value

static func get_speed_color(speed: float, MAX_SPEED: float) -> Color:
	var t = speed / MAX_SPEED
	return Color(1, 1 - t, 1 - t)

static func random_range(rangeValue: float) -> float:
	return randf_range(-rangeValue, rangeValue)
