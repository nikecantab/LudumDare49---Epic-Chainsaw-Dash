extends AudioStreamPlayer

const music_1 = preload("res://Sounds/Battle_-_Mean_Machine.ogg")
const music_2 = preload("res://Sounds/Theme_-_Spring_Off_ALT_LOOP.ogg")
const music_3 = preload("res://Sounds/Theme_-_Spring_Off.ogg")
const ambience = preload("res://Sounds/Afternoon_Birds_01_Loop.ogg")

var music = music_1


export var is_music = true

func _ready():
	Events.connect("start_music_normal", self, "_on_start_music_normal")	
	Events.connect("start_music_anticipation", self, "_on_start_music_anticipation")	
	Events.connect("start_music_grinding", self, "_on_start_music_grinding")	
	
	if is_music:
		stream = music
	else:
		stream = ambience
#	ambiencePlayer.set_bus("Ambience")
#	ambiencePlayer.stream = ambience

func _on_AudioStreamPlayer_finished():
	if playing == false:
		play()

func _process(delta):
	pass
	
func _on_start_music_normal():
		set_bus("Master")
func _on_start_music_anticipation():
		set_bus("Anticipation")
func _on_start_music_grinding():
		set_bus("Grinding")
