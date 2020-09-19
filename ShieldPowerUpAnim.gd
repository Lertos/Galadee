extends Sprite

var timer

func _ready():
	timer = Timer.new()
	timer.connect("timeout", self, "tick")
	add_child(timer)
	timer.wait_time = 0.4
	timer.start()
	
func tick():
	if self.frame > 2:
		self.frame = 2
	else:
		self.frame = 3
