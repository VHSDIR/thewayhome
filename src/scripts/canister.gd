extends Node
const LITERS_OF_GASOLINE= 10;
func _on_area_3d_body_entered(body):
	var isItPlayer = body.name == "Player"
	if isItPlayer:
		body.add_player_gasoline(LITERS_OF_GASOLINE);
