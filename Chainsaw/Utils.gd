extends Node

func instance_scene_on_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instance()
	main.add_child(instance)
	instance.global_position = position
	return instance

func nonzerosign(value):
	if value != 0:
		return sign(value)
	else:
		return 1
