extends Node3D
var other = preload("res://scripts/object/other.gd")
var randomNumberGenerator = RandomNumberGenerator.new()
var NUM_OF_OBSTACLES
var OBSTACLES
var OBSTALES_RANGE = 5
func _ready():
	NUM_OF_OBSTACLES = $Randomizer.get_child_count()
	OBSTACLES = $Randomizer.get_children()
	reset_obstacles()
func _on_player_custom_position_reseted():
	$Level/StartSign.scale = Vector3.ZERO
	reset_obstacles()
func reset_obstacles():
	var picked_obstacle = 2 # randomNumberGenerator.randi_range(0, NUM_OF_OBSTACLES - 1)
	if picked_obstacle == 0:
		$Randomizer/Sarna.position.x = other.random_range(OBSTALES_RANGE)
	elif picked_obstacle == 1:
		$Randomizer/ObstaclesHolder/Obstacle01.position.x = other.random_range(OBSTALES_RANGE)
		$Randomizer/ObstaclesHolder/Obstacle02.position.x = other.random_range(OBSTALES_RANGE)
	elif picked_obstacle == 2:
		$Randomizer/Przystanek.reinitialize();
	elif picked_obstacle == 3:
		$Randomizer/ObstacleBirds/Birds.resetAfterLevelReset()
	for i in range(NUM_OF_OBSTACLES):
		var obstacle = OBSTACLES[i]
		if i == picked_obstacle:
			obstacle.position.y = 0;
			obstacle.scale = Vector3.ONE
		else:
			obstacle.scale = Vector3.ZERO
			obstacle.position.y = -100;
func _on_player_custom_player_horn():
	$Randomizer/ObstacleBirds/Birds.scare_birds_if_player_is_close_enough()
func _on_birds_custom_player_run_over_birds():
	get_tree().change_scene_to_file("res://scenes/menu/bird_menu.tscn")
func _on_player_custom_player_stop():
	$Randomizer/Przystanek.notify_that_bus_has_stoped();
func _on_przystanek_custom_player_rollover_passanger():
	print("game over, gracz przejechał pasażera")

func _on_przystanek_custom_player_buss_taken_enemy():
	print("game over, wziął wampira")

func _on_przystanek_custom_player_buss_taken_passanger():
	print("jest git, wziął pasażera")

func _on_przystanek_custom_player_did_not_take_passanger():
	print("game over, nie wziął pazażera")
