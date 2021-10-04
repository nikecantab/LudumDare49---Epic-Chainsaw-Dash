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
onready var mouseCast = $MouseCast
onready var launchCast = $LaunchCast

onready var animator = $AnimationPlayer

const constraint = preload("res://Chainsaw/PlayerConstraint.tscn")
var c

enum {	FREEFALL, LAUNCHING, STUCK }

var state = FREEFALL
var last_state
var target
var trunkTarget = null
var conserve_velocity 

onready var collision_l = collision_layer
onready var collision_m = collision_mask

var frame = 0

func _ready():
#	apply_impulse(Vector2(100, -20), Vector2(50.0,-100.0))
#	apply_torque_impulse(3000)
	print(collision_l, ", real l: ", collision_layer)
	print(collision_m, ", real m: ", collision_mask)
	pass

func _process(delta):
	last_state = state
	frame = (frame + 1) % 3

	
	match(state):
		FREEFALL:
				
			Events.emit_signal("start_music_normal")
			
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
#				apply_torque_impulse(clamp(linear_velocity.length(), 0, 300))
				angular_velocity = 30
				
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
#			linear_velocity = Vector2.ZERO
#			print("constraint: ", c.global_position, ", position: ", global_position)
			if Input.is_action_pressed("launch"):
				animator.play("HyperSpeed")
				Events.emit_signal("start_music_grinding")
				Events.emit_signal("add_screenshake", .01,.01)
				$Particles2D.emitting = true
			elif Input.is_action_just_released("launch"):
					trunkTarget.queue_free()
					toggle_physics(true)
					state = FREEFALL
					$Particles2D.emitting = false
					
			else:
				animator.play("Slow")
				Events.emit_signal("start_music_anticipation")
			pass
	if frame == 0:
#		print(sleeping, ", contact monitor: ", contact_monitor, ", can sleep: ", can_sleep)
#		print("state: ", state)
#		print("gravity: ", gravity_scale)
#		print("velocity: ", linear_velocity.length())
#		print("angle: ", angular_velocity)
		pass
		
	if last_state != state:
#		$Timer.wait_time = 1
		$Timer.start()
			
		print("state:", state, ", last:", last_state)
		print("layer:", collision_layer)
		print("mask:", collision_mask)
#		print("sleeping:", sleeping)
	


func _on_Area2D_area_entered(area):
	
	print("hitbox collided")
	state = STUCK

	var area_position = area.get_child(0).global_position
	var constraing_position = Vector2((area_position.x + global_position.x) /2, area_position.y)	
	
	c = constraint.instance()
	trunkTarget = area.get_parent()
	trunkTarget.add_child(c)
	c.remote_path = self.get_path()
	trunkTarget.linear_velocity /= 4
#	conserve_velocity = linear_velocity
	linear_velocity = Vector2.ZERO
	gravity_scale = 0
#	can_sleep = true
	toggle_physics(false)
	
func toggle_physics(value):
	if value == false:
		$PhysicsCollider.set_deferred("disabled", true)
		$Area2D/Hitbox.set_deferred("disabled", true)
	
		
		linear_velocity = Vector2.ZERO
		gravity_scale = 0
	#	can_sleep = true
#		set_deferred("collision_layer", collision_l)
#		set_deferred("collision_mask", collision_m)
		set_deferred("contact_monitor", true)
#		set_deferred("sleeping", true)
	else:
		$PhysicsCollider.set_deferred("disabled", false)
		$Area2D/Hitbox.set_deferred("disabled", false)
#		linear_velocity= conserve_velocity
		gravity_scale = DEFAULT_GRAV
	#	can_sleep = true
#		set_deferred("collision_layer", 0)
#		set_deferred("collision_mask", 0)
		set_deferred("contact_monitor", false)
		set_deferred("sleeping", true)

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
	

#rubberband solution
func _on_Timer_timeout():
#	print("timeout")
	if state != STUCK:
		state = FREEFALL
