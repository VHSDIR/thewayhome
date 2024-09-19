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
	$Enviroment/StartSign.scale = Vector3.ZERO
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
	elif picked_obstacle == 3:
		$Randomizer/ObstacleBirds/Birds.resetAfterLevelReset()
	for i in range(NUM_OF_OBSTACLES):
		OBSTACLES[i].scale = Vector3.ONE if i == picked_obstacle else Vector3.ZERO
func _on_player_custom_player_horn():
	$Randomizer/ObstacleBirds/Birds.scare_birds_if_player_is_close_enought()
func _on_birds_custom_player_run_over_birds():
	get_tree().change_scene_to_file("res://scenes/bird_death.tscn")
