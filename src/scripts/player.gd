extends CharacterBody3D

var CURRENT_SPEED = 0
const ROTATION_SPEED = 1.5
var PREVIOUS_POSITION: Vector3;

@export var camera_node : Node3D

func float_to_speed(value: float) -> String:
	# "%.1f" formats the float to one decimal point
	return "%0.1f" % value

func _physics_process(delta):
	if PREVIOUS_POSITION == null:
		PREVIOUS_POSITION = global_position;

	if not is_on_floor():
		velocity += get_gravity() * delta

	var isAcceleratePressed = Input.is_action_pressed("move_front");
	if isAcceleratePressed:
		CURRENT_SPEED += delta
	elif CURRENT_SPEED > 0:
		CURRENT_SPEED -= delta
		if CURRENT_SPEED < 0:
			CURRENT_SPEED = 0;

	var input_dir = Input.get_vector("rotate_left", "rotate_right", "move_back", "move_front")
	var direction = (transform.basis * Vector3(
		input_dir.x,
		0,
		1 # jedynka ale nie wiem czemu
	)).normalized()
	if direction:
		velocity.x = CURRENT_SPEED * direction.x;
		velocity.z = CURRENT_SPEED * direction.z;
	else:
		velocity.x = move_toward(velocity.x, 0, CURRENT_SPEED)
		velocity.z = move_toward(velocity.z, 0, CURRENT_SPEED)

	if Input.is_action_pressed("rotate_left"):
		rotate_y(ROTATION_SPEED * delta)
	elif Input.is_action_pressed("rotate_right"):
		rotate_y(-ROTATION_SPEED * delta)

	var distance = position.distance_to(PREVIOUS_POSITION)
	var speed = distance / delta
	PREVIOUS_POSITION = position

	$Control/Label.text = float_to_speed(speed);

	move_and_slide()
