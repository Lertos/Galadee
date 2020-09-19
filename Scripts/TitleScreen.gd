extends Control

const STAR_SCENE = preload("res://Star.tscn")

var scene_path_to_load
var timer
var rng = RandomNumberGenerator.new()

func _ready():
	
	get_viewport().size = Vector2(1280,720)
	
	$RotateBackground.play("RotateTitleBackground")
	
	rng.randomize()
	
	timer = Timer.new()
	timer.connect("timeout", self, "tick")
	add_child(timer)
	timer.wait_time = 0.5
	timer.start()
	
	for button in $Menu.get_children():
		button.connect("pressed", self, "on_Button_pressed", [button.scene_to_load])

func tick():
	var star = STAR_SCENE.instance()
	self.add_child(star)
	star.global_position.x = (rng.randi() % int(get_viewport().get_size().x))
	star.global_position.y = (rng.randi() % int(get_viewport().get_size().y))
		
func on_Button_pressed(scene):
	scene_path_to_load = scene
	timer.stop()
	$Fade.show()
	$Fade._fade_in()

func _on_Fade_fade_finished():
	get_tree().change_scene(scene_path_to_load)
