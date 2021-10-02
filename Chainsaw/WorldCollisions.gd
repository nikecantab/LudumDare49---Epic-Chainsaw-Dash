extends StaticBody2D

onready var bottom = $CollisionBottom
onready var left = $CollisionLeft
onready var right = $CollisionRight

export(NodePath) var follow

var margin = 1000

func _ready():
	follow = get_node(follow)
	
	print("collisions pos: ", left.position, right.position)
	pass
	
func _process(delta):
	if abs(follow.position.y - left.position.y) > 1500:
		left.position.y = follow.position.y
		right.position.y = follow.position.y
		print("collisions updated: ", left.position, right.position)
		
