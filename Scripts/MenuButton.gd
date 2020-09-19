extends Node

export (String) var scene_to_load

func _on_Button_mouse_entered():
	$AnimationPlayer.play("MouseOver")

func _on_Button_mouse_exited():
	$AnimationPlayer.play("MouseExit")
