extends Camera3D

# Variables for controlling the shake effect
var shake_factor: float = 0.0  # Shake intensity (0 = no shake, 1 = max shake)
var max_shake_intensity: float = 0.1  # Maximum shake intensity in world units
var shake_decay: float = 0.1   # (Optional) How fast the shake decays after each frame

# Store the original camera position and rotation to reset after shaking
var original_position: Vector3
var original_rotation: Vector3

func _ready():
	# Save the original camera position and rotation when the scene starts
	original_position = position
	original_rotation = rotation

# Update the camera shake effect every frame
func _process(_delta: float):
	if shake_factor > 0:
		# Calculate the actual shake intensity based on the shake_factor
		var actual_intensity = shake_factor * max_shake_intensity
		
		# Apply random shaking to the camera's position and optionally rotation
		# position = original_position + Vector3(
		#	randf_range(-actual_intensity, actual_intensity),
		#	randf_range(-actual_intensity, actual_intensity),
		#	randf_range(-actual_intensity, actual_intensity)
		# )
		
		# (Optional) You can shake the rotation as well for more dynamic shaking
		rotation = original_rotation + Vector3(
			randf_range(-actual_intensity, actual_intensity) * 0.05,
			randf_range(-actual_intensity, actual_intensity) * 0.05,
			randf_range(-actual_intensity, actual_intensity) * 0.05
		)
	else:
		# Reset the camera position and rotation when no shaking is applied
		position = original_position
		rotation = original_rotation

# Utility function to get a random float within a range
func randf_range(min: float, max: float) -> float:
	return randf() * (max - min) + min

# Function to set the shake factor (between 0 and 1)
func set_shake_factor(new_factor: float):
	shake_factor = clamp(new_factor, 0.0, 1.0)
