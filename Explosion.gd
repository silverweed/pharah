extends Particles

func _ready():
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.connect("timeout", self, "queue_free")
	timer.start()
	add_child(timer)