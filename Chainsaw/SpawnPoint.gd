extends Node2D

export(int) var range_x = 10

const trunk = preload("res://Level/FallingTrunk.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var instance = trunk.instance()
	add_child(instance)
	instance.global_position = global_position
	instance.position = position
	instance.position.x =  position.x + rand_range(-range_x, range_x)
	$Timer.start()
	print("timeout")
