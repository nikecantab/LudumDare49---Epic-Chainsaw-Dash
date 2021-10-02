extends Camera2D

var shake = 0
var zoom_target = 1
var zoom_speed = 0
#var zoom_in = false
var frame = 0

onready var shakeTimer = $ScreenshakeTimer
onready var zoomTimer = $ZoomTimer

func _ready():
# warning-ignore:return_value_discarded
	Events.connect("add_screenshake", self, "_on_Events_add_screenshake")
# warning-ignore:return_value_discarded
	Events.connect("zoom", self, "_on_Events_zoom")
	
# warning-ignore:unused_argument
func _process(delta):
	frame = (frame + 1) % 3
	#screenshake
	offset_h = rand_range(-shake, shake)
	offset_v = rand_range(-shake, shake)
	shake *= .9
	
	#zoom
	var z = lerp(zoom.x, zoom_target, zoom_speed)
	if abs(fmod(z,1.0)) < 0.05:
		if frame == 0:
			print(z)
			print(zoom.x)
		z = round(z)
	zoom = Vector2(z,z)
	
func screenshake(amount, duration):
	#NOTE:
	#screenshake does not affect characters for some reason, could be canvas layer
	shake += amount
	shakeTimer.wait_time += duration
	shakeTimer.start()

#add_zoom

func _on_ScreenshakeTimer_timeout():
	shake = 0

func _on_ZoomTimer_timeout():
#	zoom_in = false
	zoom_target = 1
	zoom_speed = 0.01
	pass


func _on_Events_add_screenshake(amount, duration):
#	print("screenshake %d, " % amount, duration)
	screenshake(amount, duration)

func _on_Events_zoom(level, speed):
	zoom_target = level
	zoom_speed = speed
	zoomTimer.start()
#	zoom_in = true
	pass
