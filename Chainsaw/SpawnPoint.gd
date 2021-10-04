extends Node2D

export(int) var range_x = 200
export(int) var range_y = 50
export(int) var spawn_time = 5
export(int) var spawn_amount = 1
export var trunks = []

const trunk = preload("res://Level/FallingTrunk.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in trunks:
		i.connect("died", self, "_on_died")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	for i in spawn_amount:
		var instance = trunk.instance()
		add_child(instance)
		instance.global_position = global_position
		seed(i)
		instance.position.y = rand_range(-range_y, range_y)
		instance.position.x =  rand_range(-range_x, range_x)
		trunks.append(instance)
	$Timer.start(spawn_time)
	if trunks.size() > 20:
		var oldest = trunks.pop_front()
		oldest.queue_free()
	print("timeout")

func _on_died(trunk):
	for i in trunks:
		if trunks[i] == trunk:
			trunks.remove(i)
