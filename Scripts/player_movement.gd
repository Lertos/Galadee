extends KinematicBody2D

signal death
signal health_loss

#So other nodes can know the dimensions of this nodes sprite
export (int) var sprite_width
export (int) var sprite_height

#Controls how fast the player can move
export (int) var speed = 175

#Controls the number of bullets the player shoots
export (bool) var isPowered = false
export (bool) var isProtected = false

export (int) var health = 3

var friction = 0.1
var acceleration = 0.1
var velocity = Vector2.ZERO

#For the shield power up
var shieldTimer
var shieldDuration = 10

#For the bullet power up
var bulletTimer
var bulletDuration = 8

func _ready():
	var spriteNode = self.get_node("sprite")
	var spriteTexture = spriteNode.get_texture()
	
	sprite_width = spriteTexture.get_width() / spriteNode.hframes
	sprite_height = spriteTexture.get_height() / spriteNode.vframes

func _physics_process(delta):
	var input_velocity = Vector2.ZERO
	# Check input for "desired" velocity
	
	if Input.is_action_pressed("right"):
		if (self.position.x + 32) < get_viewport().get_size().x:
			input_velocity.x += 1
	if Input.is_action_pressed("left"):
		if (self.position.x - 32) > 0:
			input_velocity.x -= 1
	if Input.is_action_pressed("down"):
		if (self.position.y + 32) < get_viewport().get_size().y:
			input_velocity.y += 1
	if Input.is_action_pressed("up"):
		if (self.position.y - 32) > 0:
			input_velocity.y -= 1
	input_velocity = input_velocity.normalized() * speed

	# If there's input, accelerate to the input velocity
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
		# If there's no input, slow down to (0, 0)
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)

func _calculate_hit():
	if(self.isProtected == true):
		_disable_protection()
	else:
		emit_signal("health_loss")
		if(self.health > 1):
			self.health -= 1
			#print("Health left: " + str(self.health))
		else:
			_explode()

func _explode():
	emit_signal("death")
	queue_free()
	
func _enable_protection():
	self.isProtected = true
	$AnimationPlayer.play("FadeShield")
	$Shield_Activate.play()
	#Setup the timer for shield despawn
	self.shieldTimer = Timer.new()
	self.shieldTimer.connect("timeout", self, "_disable_protection")
	self.shieldTimer.one_shot = true
	
	add_child(self.shieldTimer)
	
	self.shieldTimer.wait_time = shieldDuration
	self.shieldTimer.start()
	
func _disable_protection():
	self.isProtected = false
	$AnimationPlayer.play("FadeShieldOut")
	$Shield_Deactivate.play()
	
func _enable_bullet_powerup():
	self.isPowered = true
	$Bullet_Activate.play()
	var background = get_node("/root/root/InfiniteBackground")
	background.changeToRed()
	#Setup the timer for bullet powerup despawn
	self.bulletTimer = Timer.new()
	self.bulletTimer.connect("timeout", self, "_disable_bullet_powerup")
	self.bulletTimer.one_shot = true
	
	add_child(self.bulletTimer)
	
	self.bulletTimer.wait_time = bulletDuration
	self.bulletTimer.start()
	
func _disable_bullet_powerup():
	self.isPowered = false
	$Bullet_Deactivate.play()
	var background = get_node("/root/root/InfiniteBackground")
	background.backToNormal()
