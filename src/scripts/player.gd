class_name player
extends CharacterBody3D
var CURRENT_SPEED = 0
const MAX_SPEED = 10.0
const ROTATION_SPEED = 2.0
const LOOPING_DISTANCE = 300
var PREVIOUS_POSITION: Vector3
@export var camera_node: Node3D

func float_to_speed(value: float) -> String:
	return "%0.1f" % value

func get_speed_color(speed: float) -> Color:
	var t = speed / MAX_SPEED
	return Color(1, 1 - t, 1 - t)
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
func _physics_process(delta):
	if PREVIOUS_POSITION == null:
		PREVIOUS_POSITION = global_position
	if not is_on_floor():
		velocity += get_gravity() * delta
	var isAcceleratePressed = Input.is_action_pressed("move_front")
	if isAcceleratePressed:
		CURRENT_SPEED += delta
	elif CURRENT_SPEED > 0:
		CURRENT_SPEED -= delta
		if CURRENT_SPEED < 0:
			CURRENT_SPEED = 0
	CURRENT_SPEED = clamp(CURRENT_SPEED, 0, MAX_SPEED)
	var input_dir = Input.get_vector("rotate_left", "rotate_right", "move_back", "move_front")
	var direction = (transform.basis * Vector3(input_dir.x, 0, 1)).normalized()
	if direction:
		velocity.x = CURRENT_SPEED * direction.x
		velocity.z = CURRENT_SPEED * direction.z
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
	$Control/SpeedMeter.text = float_to_speed(speed)
	$Control/SpeedMeter.modulate = get_speed_color(CURRENT_SPEED)
	var fps = Engine.get_frames_per_second()
	$Control/FPS.text = "FPS: %d" % fps

	$Control/CurrentZ.text = "Z: %d" % position.z

	if position.z > LOOPING_DISTANCE:
		position.z = -LOOPING_DISTANCE

	move_and_slide()
