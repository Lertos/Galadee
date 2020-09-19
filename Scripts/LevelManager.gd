extends Node

const PLAYER_SCENE = preload("res://Player.tscn")
const BULLET_SCENE = preload("res://Bullet.tscn")
const ENEMY_SCENE = preload("res://Enemy.tscn")
const HEALTH_SCENE = preload("res://Heart.tscn")
const INFINITE_BG_SCENE = preload("res://InfiniteBackground.tscn")
const FADE_OUT_SCENE = preload("res://FadeOut.tscn")

const SHIELD_POWER_SCENE = preload("res://ShieldPowerUp.tscn")
const BULLET_POWER_SCENE = preload("res://BulletPowerUp.tscn")

const POWERED_BULLET_SOUND = preload("res://Sounds/tri-blast.wav")
const BULLET_SOUND = preload("res://Sounds/bullet_new_shoot2.wav")

const GAME_OVER_TEXT = preload("res://GameOverText.tres")

#The counter used to know where we are in the order
var enemyCounter = 0

#Increment when a new enemy spawns - decrement when an enemy dies (used as win condition)
var enemyAliveCounter = 0

var enemyOrder = []
var timeBetween = []

#Other variables
var timer
var playerHealth = []
var rng = RandomNumberGenerator.new()

var streamCounter = 0

func _ready():
	#Changing the default viewport size as the original is terrible for smaller pixel art
	get_viewport().size = Vector2(300,200)
	
	self.add_child(INFINITE_BG_SCENE.instance())
	
	if(int(Global.selectedLevel) == 7):
		$BackgroundMusic_Final_Level.play()
	else:
		$BackgroundMusic.play()
	
	enemyOrder = Global.levelSetup[int(Global.selectedLevel)]["enemyOrder"]
	timeBetween = Global.levelSetup[int(Global.selectedLevel)]["timeBetween"]
	
	#Uses a timed based seed to randomize numbers
	rng.randomize()
	
	#Setup the timer for spawning enemies
	timer = Timer.new()
	timer.connect("timeout", self, "_spawn_enemy")
	add_child(timer)
	timer.wait_time = 3 #Default time of 3 to give the player a second to breathe
	timer.start()
	
	_spawn_player()
	
	$Player.connect("death", self, "_stop_game_loss")
	$Player.connect("health_loss", self, "_remove_life")
	
	for i in $Player.health:
		var newHealth = HEALTH_SCENE.instance()
		self.playerHealth.push_front(newHealth)
		
		newHealth.position.x = (i+1)*20
		newHealth.position.y = 20
		
		newHealth.texture.set_flags(0)
		self.add_child(newHealth)
		
	self.add_child(FADE_OUT_SCENE.instance())
	$FadeOut._fade_in()

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
		get_tree().change_scene("res://LevelSelectScreen.tscn")

#Spawns the player in the bottom-center of the screen when the level starts
func _spawn_player():
	var player = PLAYER_SCENE.instance()
	
	player.position.x = get_viewport().get_size().x/2
	player.position.y = get_viewport().get_size().y/4 * 3
	
	self.add_child(player)

#Spawns a bullet at the given position with the given directions
func _spawn_bullet(position, xdir, ydir, type = ""):
	var bullet = BULLET_SCENE.instance()
	
	self.add_child(bullet)
	
	if(type == "enemy"):
		bullet.name = "EnemyBullet"
	else:
		bullet.name = "AllyBullet"
	
	bullet.velocity_direction_x = xdir
	bullet.velocity_direction_y = ydir
	
	bullet.global_position = position
	bullet.global_position.y -= 10
	
	if type != "enemy" and $Player.isPowered == true:
		play_custom_sound(POWERED_BULLET_SOUND, -21)
	else:
		play_custom_sound(BULLET_SOUND, -15)

func play_custom_sound(sound, vol):
	var audio = AudioStreamPlayer.new()
	self.add_child(audio)
	
	audio.volume_db = vol
	audio.stream = sound
	
	audio.name = "a" + str(streamCounter)
	
	audio.play()
	audio.connect("finished", self, "free_stream", [streamCounter])
	
	streamCounter += 1

func free_stream(counter):
	var node = get_node("/root/root/a" + str(counter))
	node.queue_free()

#Spawns an enemy based on the progress of the level
func _spawn_enemy():
	
	#If there are no more enemies to spawn, stop the timer
	if(enemyCounter >= self.enemyOrder.size()):
		timer.stop()
		return
	
	var enemy = ENEMY_SCENE.instance()
	
	#Handle which enemy type gets spawn, and how long until the next enemy spawns
	var enemyType = null
	var powerUp = null
	
	if(self.enemyOrder[self.enemyCounter] == "Small"):
		enemyType = Global.smallEnemy
	elif(self.enemyOrder[self.enemyCounter] == "Medium"):
		enemyType = Global.mediumEnemy
	elif(self.enemyOrder[self.enemyCounter] == "Large"):
		enemyType = Global.largeEnemy
	elif(self.enemyOrder[self.enemyCounter] == "Shield"):
		powerUp = SHIELD_POWER_SCENE.instance()
	elif(self.enemyOrder[self.enemyCounter] == "Bullet"):
		powerUp = BULLET_POWER_SCENE.instance()
		
	if(enemyType != null):
		#Setup the selected enemy with the predefined attributes
		enemy.spriteFile = enemyType[0]
		enemy.spriteWidth = enemyType[1]
		enemy.spriteHeight = enemyType[2]
		enemy.hframes = enemyType[3]
		enemy.vframes = enemyType[4]
		enemy.desiredRotation = enemyType[5]
		enemy.colliderPosX = enemyType[6]
		enemy.colliderPosY = enemyType[7]
		enemy.colliderScaleX = enemyType[8]
		enemy.colliderScaleY = enemyType[9]
		enemy.type = enemyType[10]
		enemy.speed_x = enemyType[11]
		enemy.speed_y = enemyType[12]
		enemy.health = enemyType[13]
		self.add_child(enemy)
		
		enemy.global_position.x = (rng.randi() % int(get_viewport().get_size().x - (enemy.spriteWidth*6)) + int(enemy.spriteWidth*3))
		enemy.global_position.y = enemy.spriteHeight * -1
		
	else:
		self.add_child(powerUp)

		powerUp.global_position.x = (rng.randi() % int(get_viewport().get_size().x - (get_viewport().get_size().x/3))) + (get_viewport().get_size().x/6)
		powerUp.global_position.y = -16
	
	#Update the timer to wait the selected amount of time before spawning the next enemy
	timer.wait_time = self.timeBetween[self.enemyCounter]
	
	if(enemyType != null):
		#Connect the death signal to the new enemy
		enemy.connect("death", self, "_enemy_death")
		
		if(self.enemyOrder[self.enemyCounter] == "Large"):
			enemy.connect("shoot", self, "_enemy_shoot")
			
		self.enemyAliveCounter += 1
		
	self.enemyCounter += 1


func _enemy_shoot(pos):
	_spawn_bullet(pos, 0, 1, "enemy")

func _enemy_death():
	#print("Death: " + str(enemyAliveCounter))
	self.enemyAliveCounter -= 1

	if(enemyCounter >= self.enemyOrder.size()):
		if(self.enemyAliveCounter <= 0):
			_stop_game_win()


func _remove_life():
	var healthToRemove = self.playerHealth.front()
	self.remove_child(healthToRemove)
	self.playerHealth.pop_front()
	$Health_Loss.play()
	$GetHit.play("flashRed")


func _stop_game_win():
	print("Stop game win")

	yield(get_tree().create_timer(1.0), "timeout")
	$Game_Win.play()
	_game_over_label("w")
	
	yield(get_tree().create_timer(5.0), "timeout")
	get_tree().change_scene("res://LevelSelectScreen.tscn")


func _stop_game_loss():
	timer.stop()
	print("Stop game win")	
	
	yield(get_tree().create_timer(1.0), "timeout")
	$Game_Over.play()
	_game_over_label("l")
	
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://LevelManager.tscn")

func _game_over_label(winOrLoss):
	var labelText = ''
	if winOrLoss == 'w':
		labelText = 'You Win!'
	else:
		labelText = 'You Lose'
	
	var label = Label.new()
	label.text = labelText
	label.add_font_override("font",GAME_OVER_TEXT)
	label.ALIGN_CENTER
	var size_x = label.get_combined_minimum_size().x
	var size_y = label.get_combined_minimum_size().y
	label.set_global_position(Vector2(get_viewport().get_size().x/2-size_x/2, get_viewport().get_size().y/2-size_y/2))
	self.add_child(label)
