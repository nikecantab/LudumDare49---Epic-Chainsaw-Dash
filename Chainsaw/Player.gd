extends Node2D

var target

onready var chainsaw = $Chainsaw

func _input(event):
	if Input.is_action_just_pressed("launch"):
		target = get_global_mouse_position()
#		print("mouse from player: ", target)

#
#onready var chainsaw = $Chainsaw
#onready var mouseCast = $Locator/MouseCast
#onready var launchCast = $Locator/LaunchCast
#
#func pass_location():
##	$Chainsaw.
#	pass
#
#
#func _process(delta):
#	mouseCast.cast_to = get_local_mouse_position()
#	launchCast.cast_to = -get_local_mouse_position().normalized() * LAUNCH_OFFSET
#
#	chainsaw.mouseCast = mouseCast.cast_to
#	chainsaw.launchCast = launchCast.cast_to
