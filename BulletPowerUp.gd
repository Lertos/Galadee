extends Area2D

export (int) var speed = 150
	
func _physics_process(delta):
	
	if self.position.y > get_viewport().get_size().y:
		queue_free()
	
	var velocity_x = (speed * 0) * delta
	var velocity_y = (speed * 1) * delta
	position.x += velocity_x
	position.y += velocity_y

func _on_BulletPowerUp_body_entered(body):
	if("Player" in body.get_name()):
		var player = get_node("/root/root/Player")
		if(player.isPowered == false):
			player._enable_bullet_powerup()
		queue_free()
