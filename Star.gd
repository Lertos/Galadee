extends Sprite

var timer
var reversed = false

func _ready():
	timer = Timer.new()
	timer.connect("timeout", self, "tick")
	add_child(timer)
	timer.wait_time = 0.1
	timer.start()
	
func tick():
	if reversed == false and self.frame < 3:
		self.frame += 1
	else:
		if reversed == false:
			reversed = true
		if self.frame > 0:
			self.frame -= 1
		else:
			queue_free()
