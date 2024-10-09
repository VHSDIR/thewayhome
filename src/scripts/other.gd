extends Node
static var randomNumberGenerator = RandomNumberGenerator.new()
static func float_to_speed(value: float) -> String:
	return "%0.1f" % value
static func float_to_two_decimal_places(value: float) -> String:
	return "%0.2f" % value
static func get_speed_color(speed: float, MAX_SPEED: float) -> Color:
	var t = speed / MAX_SPEED
	return Color(1, 1 - t, 1 - t)
static func random_range(rangeValue: float) -> float:
	return randf_range(-rangeValue, rangeValue)
static func cast_value_range_to_factor(value: float, valueMin: float, valueMax: float) -> float:
	var diff = valueMax - valueMin;
	return clamp((value - valueMin) / diff, 0, 1);
static func pick_random_value(values: Array) -> Variant:
	if values.size() == 0:
		return null
	var random_index = randi() % values.size()
	return values[random_index]
static func get_child_names_from_node(node: Node) -> Array:
	var names = []
	for child in node.get_children():
		names.append(child.name)
	return names
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
		speed = clamp(currentSpeed - accelerationFactor * deltaTime, 0, currentSpeed)
	else:
		if currentSpeed > 0:
			speed = clamp(currentSpeed - deccelerationFactor * deltaTime, 0, currentSpeed)
		elif currentSpeed < 0:
			speed = clamp(currentSpeed + deccelerationFactor * deltaTime, 0, currentSpeed);
	return clamp(speed, maxReverseSpeed, maxSpeed)
static func get_random_sign() -> int:
	if randi() % 2 == 0:
		return 1
	return -1
static func calculate_gas_consumtion(totalFuel: float, currentSpeed: float, maxSpeed: float, isAccelerating: bool, timeDelta: float) -> Array:
	var currentSpeedFactor = currentSpeed / maxSpeed
	var fuel_decrease = timeDelta * currentSpeedFactor if isAccelerating else 0;
	var fuel_after_decrease = totalFuel - fuel_decrease
	var fuel_consumption = fuel_decrease * currentSpeed

	return [fuel_after_decrease, fuel_consumption]
