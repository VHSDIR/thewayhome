extends CharacterBody3D
var helpers = preload("res://scripts/helpers.gd")
var CURRENT_SPEED = 0
const MAX_SPEED = 10.0
const REVERSE_SPEED = -5.0
const ACCELERATION = 2.0
const COAST_DECELERATION = 4.0
const ROTATION_SPEED = 2.0
const LOOPING_DISTANCE = 100
const SIDEROAD_START_X = 2
const SIDEROAD_MAX_X = 4
var PREVIOUS_POSITION: Vector3
var points = 0
signal custom_position_reseted
signal custom_player_horn
@export var camera_node: Node3D
@export var horn_player: AudioStreamPlayer
func _ready():
	$Control/SpeedMeter.visible = true
	$Control/FPS.visible = true
	$Control/PauseMenu.visible = false
	$Control/Position.visible = true
	$Control/Resets.visible = true
	_update_resets_display()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
func _on_continue_pressed():
	restore_ui_elements()
func toggle_pause_menu():
	if $Control/PauseMenu.visible:
		$Control/PauseMenu.visible = false
		Engine.time_scale = 1
		restore_ui_elements()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		$Control/PauseMenu.visible = true
		Engine.time_scale = 0
		hide_ui_elements()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func hide_ui_elements():
	$Control/SpeedMeter.visible = false
	$Control/FPS.visible = false
	$Control/Position.visible = false
	$Control/Resets.visible = false
func restore_ui_elements():
	$Control/SpeedMeter.visible = true
	$Control/FPS.visible = true
	$Control/Position.visible = true
	$Control/Resets.visible = true
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause_menu()
	if Input.is_action_just_pressed("horn_pressed"):
		$HornPlayer.play()
		custom_player_horn.emit()
func _physics_process(delta):
	if PREVIOUS_POSITION == null:
		PREVIOUS_POSITION = global_position
	if not is_on_floor():
		velocity += get_gravity() * delta
	var isAcceleratePressed = Input.is_action_pressed("move_front")
	var isBrakePressed = Input.is_action_pressed("move_back")
	if isAcceleratePressed:
		CURRENT_SPEED += ACCELERATION * delta
	elif isBrakePressed:
		CURRENT_SPEED -= ACCELERATION * delta
	else:
		if CURRENT_SPEED > 0:
			CURRENT_SPEED -= COAST_DECELERATION * delta
		elif CURRENT_SPEED < 0:
			CURRENT_SPEED += COAST_DECELERATION * delta
	CURRENT_SPEED = clamp(CURRENT_SPEED, REVERSE_SPEED, MAX_SPEED)
	var input_dir = Input.get_vector("rotate_left", "rotate_right", "move_back", "move_front")
	var direction = (transform.basis * Vector3(input_dir.x, 0, 1)).normalized()
	if direction:
		velocity.x = CURRENT_SPEED * direction.x
		velocity.z = CURRENT_SPEED * direction.z
	else:
		velocity.x = move_toward(velocity.x, 0, abs(CURRENT_SPEED))
		velocity.z = move_toward(velocity.z, 0, abs(CURRENT_SPEED))
	if CURRENT_SPEED != 0:
		var rotation_amount = ROTATION_SPEED * delta * (abs(CURRENT_SPEED) / MAX_SPEED)
		if Input.is_action_pressed("rotate_left"):
			if CURRENT_SPEED > 0:
				rotate_y(rotation_amount)
			else:
				rotate_y(-rotation_amount)
		elif Input.is_action_pressed("rotate_right"):
			if CURRENT_SPEED > 0:
				rotate_y(-rotation_amount)
			else:
				rotate_y(rotation_amount)
	var distance = position.distance_to(PREVIOUS_POSITION)
	var speed = distance / delta
	PREVIOUS_POSITION = position
	$Control/SpeedMeter.text = helpers.float_to_speed(speed)
	$Control/SpeedMeter.modulate = helpers.get_speed_color(CURRENT_SPEED, MAX_SPEED)
	var fps = Engine.get_frames_per_second()
	$Control/FPS.text = "FPS: %d" % fps
	$Control/Position.text = "X: %d Z: %d" % [position.x, position.z]
	if position.z > LOOPING_DISTANCE:
		position.z = -LOOPING_DISTANCE
		custom_position_reseted.emit()
		_increase_points()
	var currentSpeedFactor = abs(CURRENT_SPEED) / MAX_SPEED
	var shake_factor = helpers.cast_value_range_to_factor(abs(position.x), SIDEROAD_START_X, SIDEROAD_MAX_X)
	$Camera3D.set_shake_factor(shake_factor * currentSpeedFactor)
	move_and_slide()
	global_position.x = clamp(global_position.x, -SIDEROAD_MAX_X, SIDEROAD_MAX_X)
	global_position.y = 1.25
func _increase_points():
	points += 1
	_update_resets_display()
	if points >= 3:
		_load_win_menu()
func _load_win_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/win_menu.tscn")
func _update_resets_display():
	$Control/Resets.text = "Resets: %d" % points
