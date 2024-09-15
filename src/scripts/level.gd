extends Node3D
var utils = preload("res://scripts/utils.gd")  
func _on_player_custom_position_reseted():
	$ObstaclesHolder/Obstacle01.position.x = utils.get_random_value(5)
	$ObstaclesHolder/Obstacle02.position.x = utils.get_random_value(5)
	$ObstaclesHolder/StartSign.scale = Vector3.ZERO
