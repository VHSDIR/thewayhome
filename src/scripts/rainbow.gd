class_name rainbow
extends Label
var time_passed = 0.0
var is_rainbow_active = false
func _process(delta):
	if is_rainbow_active:
		time_passed += delta
		var r = 0.5 + 0.5 * sin(time_passed * 2.0)
		var g = 0.5 + 0.5 * sin(time_passed * 2.0 + PI / 3.0)
		var b = 0.5 + 0.5 * sin(time_passed * 2.0 + 2 * PI / 3.0)
		modulate = Color(r, g, b)
	else:
		modulate = Color(1, 1, 1)
func _input(event):
	if event.is_action_pressed("toggle_rainbow"):
		is_rainbow_active = !is_rainbow_active
