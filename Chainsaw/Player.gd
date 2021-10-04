extends RigidBody2D

const MousePress = preload("res://GUI/MousePress.tscn")
export(int) var LAUNCH_FORCE = 300000
export(int) var LAUNCH_OFFSET = 10
export(int) var LAUNCH_TORQUE = 50
export(int) var LAUNCH_GRAV = 2
export(int) var DEFAULT_GRAV = 8
#
#var _motion := Vector2(0.0,0.0)
#var _rotation := 1.0 #: Vector2 #(direction, speed)
#var _force = Vector2(0.0,0.0)
#var _torque = 0.0

onready var animator = $Chainsaw/AnimationPlayer

const constraint = preload("res://Chainsaw/PlayerConstraint.tscn")

enum {	FREEFALL, LAUNCHING, STUCK }

var state = FREEFALL
var target
var trunkTarget = null
var conserve_velocity 

var frame = 0

func _ready():
	$Chainsaw.apply_impulse(Vector2(100, -20), Vector2(50.0,-100.0))
	pass

func _process(delta):
	frame = (frame + 1) % 3
	
	match(state):
		FREEFALL:
			Events.emit_signal("start_music_normal")
			
			animator.play("Slow")
			
			$Chainsaw.gravity_scale = DEFAULT_GRAV
#			print(global_position)
			
			if Input.is_action_just_pressed("launch"):
				
#				print("global pos: ", global_position)
#				print("launch position :", launchPosition)
				
				
				var targetDir = global_position.direction_to(get_global_mouse_position())
				var targetLength = global_position.distance_to(get_global_mouse_position())
#				print("target: ",targetDir)
				
				$Chainsaw.apply_central_impulse(targetDir * LAUNCH_FORCE * delta * 100)
				$Chainsaw.apply_torque_impulse(clamp($Chainsaw.linear_velocity.length(), 0, 300))
				
				state = LAUNCHING
				zoom_in()
#				gravity_scale = LAUNCH_GRAV
		LAUNCHING:
			Events.emit_signal("start_music_grinding")			
			animator.play("Fast")
#			add_central_force(Vector2.DOWN * 3)
#			print(gravity_scale)
			pass
		STUCK:
			if Input.is_action_pressed("launch"):
				animator.play("HyperSpeed")
				Events.emit_signal("start_music_grinding")
				Events.emit_signal("add_screenshake", .01,.01)
			elif Input.is_action_just_released("launch"):
				$Chainsaw.linear_velocity= conserve_velocity
			else:
				animator.play("Slow")
				Events.emit_signal("start_music_anticipation")
			pass
	if frame == 0:
#		print("state: ", state)
#		print("gravity: ", gravity_scale)
#		print("velocity: ", linear_velocity.length())
#		print("angle: ", angular_velocity)
		pass
		
	


func _on_Area2D_area_entered(area):
	
	print("hitbox collided")
	state = STUCK
	$Chainsaw/PhysicsCollider.set_deferred("disabled", true)
	$Chainsaw/Area2D/Hitbox.set_deferred("disabled", true)
	
	var area_position = area.get_child(0).global_position
	var constraing_position = Vector2((area_position.x + $Chainsaw.global_position.x) /2, area_position.y)	
	
	var c = constraint.instance()
	trunkTarget = area.get_parent()
	trunkTarget.add_child(c)
	c.remote_path = self.get_path()
	trunkTarget.linear_velocity /= 4
	conserve_velocity = $Chainsaw.linear_velocity
	$Chainsaw.linear_velocity = Vector2.ZERO
	

func _on_Chainsaw_body_entered(body):
	if state == LAUNCHING:	
		zoom_reset()
		state = FREEFALL
	pass

#effects
func zoom_in():
	Events.emit_signal("zoom", .75, 0.2)	
	Events.emit_signal("add_screenshake", .3, .3)
	
func zoom_reset():
	Events.emit_signal("zoom", 1, 0.1)	
	Events.emit_signal("add_screenshake", .1, .1)
	


#extends Node2D
#
#var target
#
#onready var chainsaw = $Chainsaw
#
#func _input(event):
#	if Input.is_action_just_pressed("launch"):
#		target = get_global_mouse_position()
##		print("mouse from player: ", target)
#
##
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
