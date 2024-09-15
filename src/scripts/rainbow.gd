class_name rainbow
extends Label
var time_passed = 0.0
func _process(delta):
	time_passed += delta
	var r = 0.5 + 0.5 * sin(time_passed * 2.0)
	var g = 0.5 + 0.5 * sin(time_passed * 2.0 + PI / 3.0)
	var b = 0.5 + 0.5 * sin(time_passed * 2.0 + 2 * PI / 3.0)
	modulate = Color(r, g, b)
