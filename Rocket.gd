extends Area

# A Rocket follows a straight line, spiraling through it.
# It explodes on contact.

const Explosion = preload("res://Explosion.tscn")

var knockback_radius = 10
var knockback_max = 1200
var knockback_min = 300

var spiral_amplitude = 0
var spiral_rad_accel = 0
var spiral_freq_x = 0
var spiral_freq_y = 0
var spiral_phase = 0

var speed = 50

var time = 0
var exploding = false

func _physics_process(delta):
	time += delta
	var xoff = min(1, (spiral_amplitude + spiral_rad_accel * time)) * sin(time * spiral_freq_x + spiral_phase)
	var yoff = min(1, (spiral_amplitude + spiral_rad_accel * time)) * cos(time * spiral_freq_y + spiral_phase)
	translate(Vector3(xoff, yoff, speed * delta))
	
	# Hackity Hack
	if global_transform.origin.y <= 0 and not exploding:
		explode()

func _on_Rocket_body_entered(body):
	#print(body.name, body.get_groups())
	if !exploding and !body.is_in_group("player") and !body.is_in_group("projectile"):
		explode()
	
func explode():
	exploding = true 
	
	# Spawn explosion
	var expl = Explosion.instance()
	expl.transform.origin = transform.origin
	expl.emitting = true
	get_parent().add_child(expl)
	
	# Apply Knockback
	var params = PhysicsShapeQueryParameters.new()
	var sphere = SphereShape.new()
	sphere.radius = knockback_radius
	params.set_shape(sphere)
	params.transform = transform
	var objs = get_world().direct_space_state.intersect_shape(params)
	for objinfo in objs:
		var obj = objinfo.collider
		#print(obj, obj.name)
		if obj is RigidBody:
			var dir = obj.global_transform.origin - global_transform.origin
			var force = lerp(knockback_max, knockback_min, max(0, dir.length() / knockback_radius))
			var appl_pt = obj.to_local(global_transform.origin)
			print("Applying impulse ", appl_pt, ": ", force)
			obj.apply_impulse(appl_pt, force * dir.normalized())
	
	var timer = Timer.new()
	timer.wait_time = $Particles.lifetime
	#print("wait = ", timer.wait_time)
	timer.connect("timeout", self, "queue_free")
	timer.start()
	add_child(timer)
	
	$MeshInstance.visible = false
	speed = 0
	$Particles.emitting = false
