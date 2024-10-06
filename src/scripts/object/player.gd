extends CharacterBody3D
var other = preload("res://scripts/object/other.gd")
var CURRENT_SPEED = 0
const MAX_SPEED = 10.0
const REVERSE_SPEED = -5.0
const ACCELERATION = 2.0
const COAST_DECELERATION = 4.0
const ROTATION_SPEED = 2.0
const MOUSE_SENSITIVITY = 0.05
const MOUSE_VERTICAL_RENGE = 30
const MOUSE_HORIZONTAL_RANGE = 90
const LOOPING_DISTANCE = 100
const SIDEROAD_START_X = 2
const SIDEROAD_MAX_X = 4
var PREVIOUS_POSITION: Vector3
var points = 0
var is_teleporting = false
signal custom_position_reseted
signal custom_player_horn
signal custom_player_stop
@onready var refCameraRotatorY = $CameraHolder/CameraRotatorY
@onready var refCameraRotatorX = $CameraHolder/CameraRotatorY/CameraRotatorX
@onready var refCameraShaker = $CameraHolder/CameraRotatorY/CameraRotatorX/CameraShaker
@onready var debugLabel = $Control/Debug
func _ready():
	$Control/SpeedMeter.visible = true
	$Control/PauseMenu.visible = false
	$Control/Debug.visible = true
	_update_debug_label()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _on_continue_pressed():
	restore_ui_elements()
func toggle_pause_menu():
	if $Control/PauseMenu.visible:
		$Control/PauseMenu.visible = false
		Engine.time_scale = 1
		restore_ui_elements()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		$Control/PauseMenu.visible = true
		Engine.time_scale = 0
		hide_ui_elements()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func hide_ui_elements():
	$Control/SpeedMeter.visible = false
	debugLabel.visible = false
func restore_ui_elements():
	$Control/SpeedMeter.visible = true
	debugLabel.visible = true
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause_menu()
	if Input.is_action_just_pressed("horn_pressed"):
		$HornPlayer.play()
		custom_player_horn.emit()
func _input(event):
	if event is InputEventMouseMotion:
		_handle_mouse_look(event.relative)
func _physics_process(delta):
	if PREVIOUS_POSITION == null:
		PREVIOUS_POSITION = global_position
	if not is_on_floor():
		velocity += get_gravity() * delta
	var isAcceleratePressed = Input.is_action_pressed("move_front")
	var isBrakePressed = Input.is_action_pressed("move_back")
	var newSpeed = other.calculate_speed(
		CURRENT_SPEED,
		isAcceleratePressed,
		isBrakePressed,
		ACCELERATION,
		COAST_DECELERATION,
		delta,
		MAX_SPEED,
		REVERSE_SPEED
	);
	var input_dir = Input.get_vector("rotate_left", "rotate_right", "move_back", "move_front")
	var direction = (transform.basis * Vector3(input_dir.x, 0, 1)).normalized()
	if direction:
		velocity.x = newSpeed * direction.x
		velocity.z = newSpeed * direction.z
	else:
		velocity.x = move_toward(velocity.x, 0, abs(newSpeed))
		velocity.z = move_toward(velocity.z, 0, abs(newSpeed))
	if newSpeed != 0:
		var rotation_amount = ROTATION_SPEED * delta * (abs(newSpeed) / MAX_SPEED)
		if Input.is_action_pressed("rotate_left"):
			if newSpeed > 0:
				rotate_y(rotation_amount)
			else:
				rotate_y(-rotation_amount)
		elif Input.is_action_pressed("rotate_right"):
			if newSpeed > 0:
				rotate_y(-rotation_amount)
			else:
				rotate_y(rotation_amount)
	var distance = position.distance_to(PREVIOUS_POSITION)
	if not is_teleporting:
		var speed = distance / delta
		$Control/SpeedMeter.text = other.float_to_speed(speed)
		$Control/SpeedMeter.modulate = other.get_speed_color(newSpeed, MAX_SPEED)
	is_teleporting = false
	PREVIOUS_POSITION = position
	_update_debug_label()
	if position.z > LOOPING_DISTANCE:
		position.z = -LOOPING_DISTANCE
		custom_position_reseted.emit()
		_increase_points()
		is_teleporting = true
	var currentSpeedFactor = abs(newSpeed) / MAX_SPEED
	var shake_factor = other.cast_value_range_to_factor(
		abs(position.x),
		SIDEROAD_START_X,
		SIDEROAD_MAX_X,
	)
	refCameraShaker.set_shake_factor(shake_factor * currentSpeedFactor)
	move_and_slide()
	global_position.y = 0
	if newSpeed == 0 && CURRENT_SPEED != 0:
		custom_player_stop.emit()
	CURRENT_SPEED = newSpeed
func _increase_points():
	points += 1
	_update_debug_label()
	if points >= 3:
		_load_win_menu()
func _load_win_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/menu/win_menu.tscn")
func _update_debug_label():
	var fps = Engine.get_frames_per_second()
	debugLabel.text = "FPS: %d | X: %d Z: %d | Resets: %d" % [fps, position.x, position.z, points]
func _handle_mouse_look(mouse_delta: Vector2):
	if Engine.time_scale == 0:
		return
	var yaw_rotation = -mouse_delta.x * MOUSE_SENSITIVITY
	refCameraRotatorY.rotate_y(deg_to_rad(yaw_rotation))
	var pitch_rotation = -mouse_delta.y * MOUSE_SENSITIVITY
	refCameraRotatorX.rotate_x(deg_to_rad(pitch_rotation))
	var camera_rotation_x = refCameraRotatorX.rotation_degrees
	camera_rotation_x.x = clamp(camera_rotation_x.x, -MOUSE_VERTICAL_RENGE, MOUSE_VERTICAL_RENGE)
	refCameraRotatorX.rotation_degrees = camera_rotation_x
	var camera_rotation_y = refCameraRotatorY.rotation_degrees
	camera_rotation_y.x = clamp(camera_rotation_y.x, -MOUSE_HORIZONTAL_RANGE, MOUSE_HORIZONTAL_RANGE)
	refCameraRotatorY.rotation_degrees = camera_rotation_y
