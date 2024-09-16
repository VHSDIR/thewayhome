class_name player
extends CharacterBody3D
var utils = preload("res://scripts/utils.gd")  
var CURRENT_SPEED = 0
const MAX_SPEED = 50.0
const ROTATION_SPEED = 2.0
const LOOPING_DISTANCE = 70
var PREVIOUS_POSITION: Vector3
var ui_visible = false
var is_pause_menu_visible = false
var points = 0
signal custom_position_reseted
@export var camera_node: Node3D
func _ready():
	$Control/SpeedMeter.visible = true
	$Control/FPS.visible = true
	$Control/Position.visible = true
	$Control/PauseMenu.visible = false
	$Control/Points.visible = true
	_update_points_display()
func toggle_ui_visibility():
	ui_visible = not ui_visible
	$Control/SpeedMeter.visible = ui_visible
	$Control/FPS.visible = ui_visible
	$Control/Position.visible = ui_visible
	$Control/Points.visible = ui_visible
func toggle_pause_menu():
	is_pause_menu_visible = not is_pause_menu_visible
	$Control/PauseMenu.visible = is_pause_menu_visible
	if is_pause_menu_visible:
		Engine.time_scale = 0
	else:
		Engine.time_scale = 1
func _process(_delta):
	if Input.is_action_just_pressed("toggle_ui"):
		toggle_ui_visibility()
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause_menu()
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
	$Control/SpeedMeter.text = utils.float_to_speed(speed)
	$Control/SpeedMeter.modulate = utils.get_speed_color(CURRENT_SPEED, MAX_SPEED)
	var fps = Engine.get_frames_per_second()
	$Control/FPS.text = "FPS: %d" % fps
	$Control/Position.text = "X: %d Y: %d Z: %d" % [position.x, position.y, position.z]
	if position.z > LOOPING_DISTANCE:
		position.z = -LOOPING_DISTANCE
		custom_position_reseted.emit()
		_increase_points()
	move_and_slide()
func _increase_points():
	points += 1
	_update_points_display()
	if points >= 3:
		_load_win_menu()
func _load_win_menu():
	get_tree().change_scene_to_file("res://scenes/win_menu.tscn")
func _update_points_display():
	$Control/Points.text = "Map Resets: %d" % points
