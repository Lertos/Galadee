extends Node

var speed = 100

#For testing purposes only

#func _ready():
	#get_viewport().size = Vector2(400,200)

func _process(delta):
	$background1.position.y += speed * delta
	$background2.position.y += speed * delta
	
	if($background1.position.y > 500):
		$background1.position.y = -1500
		
	if($background2.position.y > 500):
		$background2.position.y = -1500
		
func changeToRed():
	$ChangeTint.play("ChangeToRed")

func backToNormal():
	$ChangeTint.play("BackToNormal")
