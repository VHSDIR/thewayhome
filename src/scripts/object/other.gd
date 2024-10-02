extends Node
static var randomNumberGenerator = RandomNumberGenerator.new()
static func float_to_speed(value: float) -> String:
	return "%0.1f" % value
static func get_speed_color(speed: float, MAX_SPEED: float) -> Color:
	var t = speed / MAX_SPEED
	return Color(1, 1 - t, 1 - t)
static func random_range(rangeValue: float) -> float:
	return randf_range(-rangeValue, rangeValue)
static func cast_value_range_to_factor(value: float, valueMin: float, valueMax: float) -> float:
	var diff = valueMax - valueMin;
	return clamp((value - valueMin) / diff, 0, 1);
static func calculate_speed(
	currentSpeed: float,
	isAcceleratePressed: bool,
	isBrakePressed: bool,
	accelerationFactor: float,
	deccelerationFactor: float,
	deltaTime: float,
	maxSpeed: float,
	maxReverseSpeed: float
) -> float:
	var speed = 0
	if isAcceleratePressed:
		speed = currentSpeed + accelerationFactor * deltaTime
	elif isBrakePressed:
		speed = currentSpeed - accelerationFactor * deltaTime
	else:
		if currentSpeed > 0:
			speed = currentSpeed - deccelerationFactor * deltaTime
		elif currentSpeed < 0:
			speed = currentSpeed + deccelerationFactor * deltaTime
	return clamp(speed, maxReverseSpeed, maxSpeed)
