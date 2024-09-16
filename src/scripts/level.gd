class_name level
extends Node3D
var helpers = preload("res://scripts/helpers.gd")
var randomNumberGenerator = RandomNumberGenerator.new()
var NUM_OF_OBSTACLES
var OBSTACLES
var OBSTALES_RANGE = 5

func _ready():
	NUM_OF_OBSTACLES = $Randomizer.get_child_count()
	OBSTACLES = $Randomizer.get_children()
	reset_obstacles()
func _on_player_custom_position_reseted():
	$StartSign.scale = Vector3.ZERO
	reset_obstacles()
func reset_obstacles():
	var picked_obstacle = randomNumberGenerator.randi_range(0, NUM_OF_OBSTACLES - 1)
	if picked_obstacle == 0:
		$Randomizer/ObstacleAction02.position.x = helpers.random_range(OBSTALES_RANGE)
	elif picked_obstacle == 1:
		$Randomizer/ObstaclesHolder/Obstacle01.position.x = helpers.random_range(OBSTALES_RANGE)
		$Randomizer/ObstaclesHolder/Obstacle02.position.x = helpers.random_range(OBSTALES_RANGE)
	elif picked_obstacle == 2:
		$Randomizer/ObstacleAction01.position.x = helpers.random_range(OBSTALES_RANGE)
	for i in range(NUM_OF_OBSTACLES):
		var child = OBSTACLES[i]
		if i == picked_obstacle:
			child.scale = Vector3.ONE
		else:
			child.scale = Vector3.ZERO
