extends Node

const GRAVITY_ACCEL = Vector3(0, -15, 0)

signal window_size_changed

func _ready():
	randomize()
	
func _input(event):
	if event.is_action_pressed("maximize"):
		OS.window_maximized = !OS.window_maximized
		emit_signal("window_size_changed")
		