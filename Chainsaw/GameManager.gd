extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _unhandled_input(event):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
