extends Sprite

func _ready():
	reposition()
	$"/root/Globals".connect("window_size_changed", self, "reposition")
	
func reposition():
	position = OS.window_size / 2