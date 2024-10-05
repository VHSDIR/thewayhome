extends Node
var other = preload("res://scripts/object/other.gd")
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
			bird.position = Vector3(9999, 9999, 9999)
func scare_birds_if_player_is_close_enough():
	if hasPlayerInRange:
		areBirdsOnScaredAway = true;
func resetAfterLevelReset():
	for bird in birds:
		if bird:
			bird.position = Vector3.ZERO;
	for i in range(birds.size()):
		birdsDirections[i] = other.random_range(1);
	areBirdsOnScaredAway = false;
	hasPlayerInRange = false;
func _on_closer_area_3d_body_entered(body):
	var isItPlayer = body.name == "Player"
	if isItPlayer and !areBirdsOnScaredAway:
		custom_player_run_over_birds.emit()
func _on_far_area_3d_body_entered(body):
	var isItPlayer = body.name == "Player"
	if isItPlayer:
		hasPlayerInRange = true;
