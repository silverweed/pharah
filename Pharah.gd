extends KinematicBody

const Rocket = preload("res://Rocket.tscn")

const JETPACK_THRUST_ACCEL = 28
const MOUSE_SENSITIVITY = 0.005

var speed = 10
var on_floor = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	
	if $BarrageLauncher.firing:
		return 
		
	# Vertical movement
	var accel = $"/root/Globals".GRAVITY_ACCEL if not on_floor else Vector3()
	
	if Input.is_action_pressed("soar"):
		accel += Vector3(0, JETPACK_THRUST_ACCEL, 0)
	
	move_and_slide(accel, Vector3(0, 1, 0))
	on_floor = is_on_floor()
	
	# WASD movement
	accel = Vector3()
	if Input.is_action_pressed("walk_fwd"):
		accel += global_transform.basis.z * speed
	if Input.is_action_pressed("walk_back"):
		accel -= global_transform.basis.z * speed
	if Input.is_action_pressed("strafe_left"):
		accel += global_transform.basis.x *speed
	if Input.is_action_pressed("strafe_right"):
		accel -= global_transform.basis.x *speed
	
	# Project the acceleration onto the xz plane
	accel = accel - accel.dot(Vector3(0, 1, 0)) * Vector3(0, 1, 0)
	transform.origin += accel * delta

		
func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		rotation.x = clamp(rotation.x + event.relative.y * MOUSE_SENSITIVITY, deg2rad(-90), deg2rad(90))
	elif event.is_action_pressed("ult") and not $BarrageLauncher.firing:
		$AudioStreamPlayer3D.play()
		$BarrageLauncher.fire()
	elif event.is_action_pressed("fire"):
		fire()
		
		
func fire():
	var rocket = Rocket.instance()
	rocket.transform = transform
	get_parent().add_child(rocket)
	