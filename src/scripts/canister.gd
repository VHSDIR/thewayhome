extends Node

const LITERS_OF_GASOLINE= 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_3d_body_entered(body):
	var isItPlayer = body.name == "Player"
	if isItPlayer:
		body.add_player_gasoline(LITERS_OF_GASOLINE);
