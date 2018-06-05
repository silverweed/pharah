extends Spatial

const Rocket = preload("res://BarrageRocket.tscn")

var firing = false

const ROCKETS_PER_SECOND = 30
const DURATION = 3
const SHOOT_RADIUS = 0.5
	
func fire():
	firing = true
	var t = 0
	var shot_interval = 1.0 / ROCKETS_PER_SECOND
	while t < DURATION:
		shoot()
		yield(get_tree().create_timer(shot_interval), "timeout")
		t += shot_interval
	firing = false
		
func shoot():
	var rocket = Rocket.instance()
	rocket.transform.origin = transform.origin + \
			Vector3(rand_range(-SHOOT_RADIUS, SHOOT_RADIUS), rand_range(-SHOOT_RADIUS, SHOOT_RADIUS), 0)
	rocket.rotation = rotation
	rocket.rotate(Vector3(0, 1, 0), deg2rad(rand_range(-30, 30)))
	rocket.spiral_amplitude = rand_range(0.1, 0.4)
	rocket.spiral_rad_accel = rand_range(0.2, 1)
	rocket.spiral_freq_x = rand_range(0, 8) * (1 if rand_range(0, 1) < 0.5 else -1)
	rocket.spiral_freq_y = rand_range(0, 8) * (1 if rand_range(0, 1) < 0.5 else -1)
	rocket.spiral_phase = rand_range(0, 6)
	rocket.speed = 80
	get_parent().add_child(rocket)