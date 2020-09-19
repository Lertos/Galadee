extends Node2D

export (int) var speed

func _process(delta):
	self.position.y += 1 * speed * delta
