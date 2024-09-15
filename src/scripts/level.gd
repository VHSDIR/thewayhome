class_name level
extends Node3D
var utils = preload("res://scripts/utils.gd")
func _ready():
	reset_obstacles()
func _on_player_custom_position_reseted():
	$StartSign.scale = Vector3.ZERO
	reset_obstacles()
func reset_obstacles():
	var num_obstacles = 3
	var picked_obstacle = randi_range(0, num_obstacles - 1)
	if picked_obstacle == 0:
		$Randomizer/ObstacleAction02.position.x = utils.get_random_value(5)
	elif picked_obstacle == 1:
		$Randomizer/ObstaclesHolder/Obstacle01.position.x = utils.get_random_value(5)
		$Randomizer/ObstaclesHolder/Obstacle02.position.x = utils.get_random_value(5)
	elif picked_obstacle == 2:
		$Randomizer/ObstaclesHolder/ObstacleAction01.position.x = utils.get_random_value(5)
	var children = $Randomizer.get_children()
	for i in range(children.size()):
		var child = children[i]
		if i == picked_obstacle:
			child.scale = Vector3.ONE
		else:
			child.scale = Vector3.ZERO
