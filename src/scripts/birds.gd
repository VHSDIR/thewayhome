extends Node
var helpers = preload("res://scripts/helpers.gd")
signal custom_player_run_over_birds;
@export var birds: Array[Node3D] = []
var areBirdsOnScaredAway = false;
var birdsDirections: Array[float]
var hasPlayerInRange = false;
func _ready():
	for i in range(birds.size()):
		birdsDirections.append(0);
func _process(delta):
	if areBirdsOnScaredAway:
		for i in range(birds.size()):
			var bird = birds[i]
			bird.position = Vector3(
				bird.position.x + birdsDirections[i] * delta,
				bird.position.y + delta,
				bird.position.z
			)
func scare_birds_if_player_is_close_enought():
	if hasPlayerInRange:
		areBirdsOnScaredAway = true;
func resetAfterLevelReset():
	for bird in birds:
		if bird:
			bird.position = Vector3.ZERO;
	for i in range(birds.size()):
		birdsDirections[i] = helpers.random_range(1);
	areBirdsOnScaredAway = false;
	hasPlayerInRange = false;
func _on_closer_area_3d_body_entered(body):
	var isItPlayer = body.name == "Player"
	if isItPlayer && !areBirdsOnScaredAway:
		custom_player_run_over_birds.emit()
func _on_far_area_3d_body_entered(body):
	var isItPlayer = body.name == "Player"
	if isItPlayer:
		hasPlayerInRange = true;
