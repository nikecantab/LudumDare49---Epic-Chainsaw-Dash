extends RigidBody2D

const MousePress = preload("res://GUI/MousePress.tscn")
export(int) var LAUNCH_FORCE = 1000000
export(int) var LAUNCH_OFFSET = 10
export(int) var LAUNCH_TORQUE = 50
export(int) var LAUNCH_GRAV = 2
export(int) var DEFAULT_GRAV = 8
#
#var _motion := Vector2(0.0,0.0)
#var _rotation := 1.0 #: Vector2 #(direction, speed)
var _force = Vector2(0.0,0.0)
var _torque = 0.0

enum {	FREEFALL, LAUNCHING, STUCK }

var state = FREEFALL
var target
onready var mouseCast = $MouseCast
onready var launchCast = $LaunchCast

onready var animator = $AnimationPlayer

var frame = 0

func _ready():
	apply_impulse(Vector2(100, -20), Vector2(50.0,-100.0))
	pass

func _process(delta):
	frame = (frame + 1) % 3
	
	match(state):
		FREEFALL:
			animator.play("Slow")
			
			gravity_scale = DEFAULT_GRAV
#			print(global_position)
			mouseCast.cast_to = get_local_mouse_position()
			launchCast.cast_to = -get_local_mouse_position().normalized()# * LAUNCH_OFFSET
			
			if Input.is_action_just_pressed("launch"):
				var launchPosition = transform.xform(launchCast.cast_to)
				var mouse_press = Utils.instance_scene_on_main(MousePress, transform.xform(mouseCast.cast_to))
				var opposite_press = Utils.instance_scene_on_main(MousePress, launchPosition)
				
#				print("global pos: ", global_position)
#				print("launch position :", launchPosition)
				
				
				var targetDir = global_position.direction_to(get_global_mouse_position())
				var targetLength = global_position.distance_to(get_global_mouse_position())
#				print("target: ",targetDir)
				
				apply_central_impulse(targetDir * LAUNCH_FORCE * delta * 100)
				apply_torque_impulse(clamp(linear_velocity.length(), 0, 300))
				
				state = LAUNCHING
				zoom_in()
#				gravity_scale = LAUNCH_GRAV
		LAUNCHING:
			animator.play("Fast")
#			add_central_force(Vector2.DOWN * 3)
#			print(gravity_scale)
			pass
	if frame == 0:
#		print("state: ", state)
#		print("gravity: ", gravity_scale)
#		print("velocity: ", linear_velocity.length())
#		print("angle: ", angular_velocity)
		pass
		
	


func _on_Area2D_area_entered(area):
	if state != FREEFALL:
		zoom_reset()
		state = FREEFALL
	
#	print("hitbox collided")

func _on_Chainsaw_body_entered(body):
	if state != FREEFALL:	
		zoom_reset()
		state = FREEFALL
	
#	print("chainsaw collided")
	pass



#effects
func zoom_in():
	Events.emit_signal("zoom", .75, 0.2)	
	Events.emit_signal("add_screenshake", .3, .3)
	
func zoom_reset():
	Events.emit_signal("zoom", 1, 0.1)	
	Events.emit_signal("add_screenshake", .1, .1)
	
