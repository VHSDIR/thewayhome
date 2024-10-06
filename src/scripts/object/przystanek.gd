extends Node3D

var other = preload("res://scripts/object/other.gd")

signal custom_player_rollover_passanger
signal custom_player_buss_taken_passanger;
signal custom_player_buss_taken_enemy;
signal custom_player_did_not_take_passanger

var isBusInside = false;
var currentPassangerName = null;
var mustTakePassanger = false;

@onready var PASSANGERS = $passangersHolder.get_children();
@onready var PASSANER_NAMES = other.get_child_names_from_node($passangersHolder);

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func reinitialize():
	currentPassangerName = other.pick_random_value(PASSANER_NAMES)
	mustTakePassanger = currentPassangerName.find("wampire") == -1
	for possiblePassanger in PASSANGERS:
		possiblePassanger.scale = Vector3.ONE if possiblePassanger.name == currentPassangerName else Vector3.ZERO

func notify_that_bus_has_stoped():
	if isBusInside:
		if mustTakePassanger:
			custom_player_buss_taken_passanger.emit()
		else:
			custom_player_buss_taken_enemy.emit()
		for possiblePassanger in PASSANGERS:
			possiblePassanger.scale = Vector3.ZERO
		currentPassangerName = null

func _on_passanger_area_3d_body_entered(body):
	var isItPlayer = body.name == "Player"
	if isItPlayer:
		custom_player_rollover_passanger.emit()

func _on_stop_area_3d_body_entered(body):
	var isItPlayer = body.name == "Player"
	if isItPlayer:
		isBusInside = true;

func _on_stop_area_3d_body_exited(body):
	var isItPlayer = body.name == "Player"
	if isItPlayer:
		isBusInside = false;

func _on_not_pass_area_3d_body_exited(body):
	var isItPlayer = body.name == "Player"
	if isItPlayer:
		if currentPassangerName != null:
			if mustTakePassanger:
				custom_player_did_not_take_passanger.emit()
