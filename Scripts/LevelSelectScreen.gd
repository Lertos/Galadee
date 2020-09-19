extends Control

var levelToLoad
var isBackButton = false
var sceneToLoad

func _ready():
	
	get_viewport().size = Vector2(1280,720)
	
	$RotateBackground.play("RotateBackground")
	
	for button in $MenuContainer/Menu1/.get_children():
		button.connect("pressed", self, "on_Button_pressed", [button.levelNumber])
	for button in $MenuContainer/Menu2/.get_children():
		button.connect("pressed", self, "on_Button_pressed", [button.levelNumber])
	for button in $MenuContainer/Menu3/.get_children():
		button.connect("pressed", self, "on_Button_pressed", [button.levelNumber])
	$BackButton.connect("pressed", self, "on_Back_Button_pressed", [$BackButton.scene_to_load])
		
func on_Button_pressed(level):
	levelToLoad = level
	$Fade.show()
	$Fade._fade_in()

func _on_Fade_fade_finished():
	if isBackButton == false:
		Global.selectedLevel = levelToLoad
		get_tree().change_scene("res://LevelManager.tscn")
	else:
		get_tree().change_scene(sceneToLoad)
	
func on_Back_Button_pressed(scene_to_load):
	sceneToLoad = scene_to_load
	isBackButton = true
	$Fade.show()
	$Fade._fade_in()
