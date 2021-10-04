extends RigidBody2D

export var health = 100
const explosion = preload("res://Level/TrunkDeath.tscn")
signal died(trunk)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_FallingTrunk_tree_exiting():
	print("died")
	emit_signal("died", self)
	Utils.call_deferred("instance_scene_on_main",explosion, global_position)

	pass # Replace with function body.
