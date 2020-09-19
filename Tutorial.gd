extends Node

const PLAYER_SCENE = preload("res://Player.tscn")
const BULLET_SCENE = preload("res://Bullet.tscn")
const HEALTH_SCENE = preload("res://Heart.tscn")
const INFINITE_BG_SCENE = preload("res://InfiniteBackground.tscn")
const FADE_OUT_SCENE = preload("res://FadeOut.tscn")

const SHIELD_POWER_SCENE = preload("res://ShieldPowerUp.tscn")
const BULLET_POWER_SCENE = preload("res://BulletPowerUp.tscn")

const POWERED_BULLET_SOUND = preload("res://Sounds/tri-blast.wav")
const BULLET_SOUND = preload("res://Sounds/bullet_new_shoot2.wav")

var timer
var playerHealth = []
var rng = RandomNumberGenerator.new()

func _ready():
	#Changing the default viewport size as the original is terrible for smaller pixel art
	get_viewport().size = Vector2(300,200)
	
	self.add_child(INFINITE_BG_SCENE.instance())
	$BackgroundMusic.play()

	#Uses a timed based seed to randomize numbers
	rng.randomize()
	
	_spawn_player()
	
	for i in $Player.health:
		var newHealth = HEALTH_SCENE.instance()
		self.playerHealth.push_front(newHealth)
		
		newHealth.position.x = (i+1)*20
		newHealth.position.y = 20
		
		newHealth.texture.set_flags(0)
		self.add_child(newHealth)
		
	self.add_child(FADE_OUT_SCENE.instance())
	$FadeOut._fade_in()
	
	self.progress_tutorial()

func _input(event):
	if event.is_action_pressed("shoot"):
		if(self.has_node("Player")):
			if($Player.isPowered == false):
				_spawn_bullet($Player.global_position, 0, -1)
			else:
				_spawn_bullet($Player.global_position, 0, -1)
				_spawn_bullet($Player.global_position, -0.5, -1)
				_spawn_bullet($Player.global_position, 0.5, -1)
	if event.is_action_pressed("endGame"):
		get_tree().change_scene("res://TitleScreen.tscn")

#Spawns the player in the bottom-center of the screen when the level starts
func _spawn_player():
	var player = PLAYER_SCENE.instance()
	
	player.position.x = get_viewport().get_size().x/2
	player.position.y = get_viewport().get_size().y/4 * 3
	
	self.add_child(player)

#Spawns a bullet at the given position with the given directions
func _spawn_bullet(position, xdir, ydir):
	var bullet = BULLET_SCENE.instance()
	
	self.add_child(bullet)
	
	bullet.velocity_direction_x = xdir
	bullet.velocity_direction_y = ydir
	
	bullet.global_position = position
	bullet.global_position.y -= 10
	
	$Sound_Shoot.play()

func spawn_shield_powerups():
	var powerUp1 = SHIELD_POWER_SCENE.instance()
	var powerUp2 = SHIELD_POWER_SCENE.instance()
	
	powerUp1.speed = 0
	powerUp2.speed = 0
	
	self.add_child(powerUp1)
	self.add_child(powerUp2)
	
	powerUp1.global_position = Vector2(get_viewport().get_size().x/4, get_viewport().get_size().y - get_viewport().get_size().y/4)
	powerUp2.global_position = Vector2(get_viewport().get_size().x - get_viewport().get_size().x/4, get_viewport().get_size().y - get_viewport().get_size().y/4)

func spawn_bullet_powerups():
	var powerUp1 = BULLET_POWER_SCENE.instance()
	var powerUp2 = BULLET_POWER_SCENE.instance()
	
	powerUp1.speed = 0
	powerUp2.speed = 0
	
	self.add_child(powerUp1)
	self.add_child(powerUp2)
	
	powerUp1.global_position = Vector2(get_viewport().get_size().x/4, get_viewport().get_size().y - get_viewport().get_size().y/4 - 32)
	powerUp2.global_position = Vector2(get_viewport().get_size().x - get_viewport().get_size().x/4, get_viewport().get_size().y - get_viewport().get_size().y/4 - 32)


func progress_tutorial():
	yield(get_tree().create_timer(2.0), "timeout")
	
	show_label("W,A,S,D to Move")
	yield(get_tree().create_timer(3.0), "timeout")
	
	$Node2D/LabelFader.play("FadeOut")
	yield(get_tree().create_timer(0.5), "timeout")
	
	show_label("Spacebar to Shoot")
	yield(get_tree().create_timer(3.0), "timeout")
	
	$Node2D/LabelFader.play("FadeOut")
	yield(get_tree().create_timer(0.5), "timeout")
	
	show_label("3 Lives - Dont Die")
	yield(get_tree().create_timer(2.0), "timeout")
	
	$Node2D/LabelFader.play("FadeOut")
	yield(get_tree().create_timer(0.5), "timeout")
	
	show_label("These Give a Shield")
	spawn_shield_powerups()
	yield(get_tree().create_timer(6.0), "timeout")
	
	$Node2D/LabelFader.play("FadeOut")
	yield(get_tree().create_timer(0.5), "timeout")
	
	show_label("These Buff Your Bullets")
	spawn_bullet_powerups()
	yield(get_tree().create_timer(6.0), "timeout")
	
	$Node2D/LabelFader.play("FadeOut")
	yield(get_tree().create_timer(0.5), "timeout")
	
	show_label("ESC to Leave Any Level")

func show_label(text):
	$Node2D/LabelFader.play("FadeIn")
	$Node2D/Label.text = text
