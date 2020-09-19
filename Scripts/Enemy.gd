extends Area2D

signal death
signal shoot

#Setup for the creation of the sprite node
export (String) var spriteFile

export (int) var spriteWidth
export (int) var spriteHeight

export (int) var hframes
export (int) var vframes

export (int) var desiredRotation

#Setup for the creation of the collider
export (float) var colliderPosX
export (float) var colliderPosY

export (float) var colliderScaleX
export (float) var colliderScaleY

#Enemy type (Small, Medium, Large)
export (String) var type

#Enemy attributes
export (int) var speed_x
export (int) var speed_y
export (int) var health

#Preloads
const ANIMATION_SCRIPT = preload("res://Scripts/sprite_animation.gd")
const EXPLOSION_SCENE = preload("res://Explosion.tscn")

#Local variables
var spriteNode

var alreadyDead = false

var velocity = Vector2.ZERO
var direction_x

var shoot_timer

func _ready():
	
	if type == "Large":	
		shoot_timer = Timer.new()
		shoot_timer.wait_time = 1
		self.add_child(shoot_timer)
		shoot_timer.connect("timeout", self, "emit_shoot_signal")
		shoot_timer.start()
	
	_createSprite()
	
	_createCollision2D()
	
	#Determines the initial direction randomly
	direction_x = randi() % 2
	if(direction_x == 0):
		direction_x = -1


func emit_shoot_signal():
	emit_signal("shoot", self.global_position)

func _createSprite():

	var sprite = Sprite.new()
	
	sprite.texture = load(self.spriteFile)
	sprite.texture.set_flags(0) #Needed to turn off mipmaps and filter for image
	
	sprite.name = "sprite"

	sprite.hframes = self.hframes
	sprite.vframes = self.vframes
	
	sprite.rotation_degrees = self.desiredRotation
	
	sprite.set_script(ANIMATION_SCRIPT)
	
	self.add_child(sprite)
	
	spriteNode = sprite


func _createCollision2D():
	var collider = CollisionShape2D.new()
	collider.shape = RectangleShape2D.new()
	
	collider.position.x = self.colliderPosX
	collider.position.y = self.colliderPosY
	
	collider.scale.x = self.colliderScaleX
	collider.scale.y = self.colliderScaleY
	
	self.add_child(collider)


func _process(delta):
	self.position.x += direction_x * speed_x * delta
	
	if(self.type == "Large"):
		if(self.position.y < self.spriteHeight):
			self.position.y += 1 * speed_y * delta
	else:
		self.position.y += 1 * speed_y * delta
	
	if(direction_x == 1):
		if(self.position.x > get_viewport().get_size().x - self.spriteWidth):
			direction_x = -1
	else:
		if(self.position.x < self.spriteWidth):
			direction_x = 1
	
	if(self.position.y > get_viewport().get_size().y + self.spriteHeight):
		if(get_node("/root/root/Player") != null):
			get_node("/root/root/Player")._calculate_hit()
		emit_signal("death")
		queue_free()


func _on_Enemy_area_entered(area):
	if("AllyBullet" in area.get_name()):
		_damage_self()	

func _on_Enemy_body_shape_entered(body_id, body, body_shape, area_shape):
	if("Player" in body.get_name()):
		var playerNode = get_node("/root/root/Player")
		#_spawn_explosion(playerNode.global_position, playerNode.speed)
		playerNode._calculate_hit()
		_damage_self()

func _damage_self():
	if(health > 1):
		health -= 1
	else:
		health -= 1 #Used as sometimes bullets come in at the same time
		
		#var playerNode = get_node("/root/root/Player")
		
		#Assign the power of killing the enemy - if any
		#_assign_power(playerNode, self.type) #REMOVED - now power up orbs

		#Start death sequence
		_spawn_explosion(self.global_position, self.speed_y)
		
		#If two bullets hit at the exact same time - this will only run for the first one to hit
		if(health == 0 and alreadyDead == false):
			alreadyDead = true
			emit_signal("death")
			
		queue_free()

func _assign_power(player, enemyType):
	if(enemyType == "Medium"):
		if(player.isProtected == false):
			player._enable_protection()
	elif(enemyType == "Large"):
		player.isPowered = true
		
func _spawn_explosion(position, speed):
	var explosion = EXPLOSION_SCENE.instance()
	
	explosion.global_position = position
	explosion.speed = speed
	
	get_tree().get_root().add_child(explosion)
	get_node("/root/root/Camera2D/ScreenShake").start()
