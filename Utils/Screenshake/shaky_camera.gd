class_name ShakyCamera
extends Camera2D

var shake_duration: float = 0.0
var shake_magnitude: float = 0.0
var shake_frequency: float = 20.0
var shake_timer: float = 0.0

var original_offset = Vector2.ZERO

@export var use_timescale: bool = true


## Shakes the camera with the given [param duration], 
## [param magnitude] defines the maximum offset, 
## [param frequency] defines how jittery the shake is.
func shake(duration: float, magnitude: float, frequency: float = 20.0):
	shake_duration = duration
	shake_magnitude = magnitude
	shake_frequency = frequency
	shake_timer = duration
	original_offset = offset 


func _process(delta: float):
	if shake_timer > 0:
		shake_timer -= delta * Engine.time_scale if use_timescale else delta
		var progress: float = shake_timer / shake_duration
		var intensity: float = shake_magnitude * progress
		
		offset = original_offset + Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		) * intensity

	else:
		offset = original_offset
