extends Area2D

export (int) var speed = 200
export (float) var velocity_direction_x #Needs to be either -1 or 1
export (float) var velocity_direction_y #Needs to be either -1 or 1
	
func _physics_process(delta):
	
	if self.position.y < -32 or self.position.y > get_viewport().get_size().y:
		queue_free()
	
	var velocity_x = (speed * velocity_direction_x) * delta
	var velocity_y = (speed * velocity_direction_y) * delta
	position.x += velocity_x
	position.y += velocity_y


func _on_Bullet_area_entered(area):
	if("AllyBullet" in self.name and "Enemy" in area.get_name()):
		queue_free()

func _on_Bullet_body_entered(body):
	if("EnemyBullet" in self.name and "Player" in body.get_name()):
		get_node("/root/root/Player")._calculate_hit()
		queue_free()
