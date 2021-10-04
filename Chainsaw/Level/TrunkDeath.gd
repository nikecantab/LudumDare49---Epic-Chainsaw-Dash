extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("explosion")
	$Particles2D2.emitting = true
	
func _process(delta):
	if $Particles2D2.emitting == false:
		call_deferred("queue_free")
	
