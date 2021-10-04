extends Node2D

export(int) var tracking_level
var level = 0
var margin = 200
var margin_low = 300

onready var stump1 = $StumpA
onready var stump2 = $StumpB

const stumpA = preload("res://Level/Tree/StumpA.tscn")
const stumpB = preload("res://Level/Tree/StumpB.tscn")

var rows = []
var default_rows = []
var row_amount = 20

func _ready():
	rows.append(stump1)
	rows.append(stump2)
	populate_rows()
	level = margin_low / 2

func add_stump(stump, row):
	var instance = stump.instance()
	add_child(instance)
#	instance.position = position
	instance.position.y -= 32 * row
	print(instance.name, ", position: ", instance.position, ", row: ", row)
	return instance

func populate_rows():
	for i in row_amount:
		var instance
		print(i, ", ", i%2)
		if i % 2 == 0:
			instance = add_stump(stumpA, i + 2)
			print("A")
		else:
			instance = add_stump(stumpB, i + 2)
			print("B")
			
		rows.append(instance)

func update_tracker(value):
	tracking_level = global_position.y - value
	if abs(tracking_level-(level*32) ) > margin:
		#update level
		var prev_level = level
		level = int(tracking_level / 32)
		
		print("camera: ", value, ", tracking level: ", tracking_level, ", level: ", level)
		#leave margin
		if level*32 > margin_low:
			#update 
			#lower go higher
			if level < prev_level:
				update_rows(true)
			#upper go lower
			else:
				update_rows(false)
		else:
			default_rows()
#	print(tracking_level)

func update_rows(lower : bool):
	print("rows updated")
	if lower: #go higher
		for i in range(0, row_amount/2):
			rows[i].position.y = (i * level) * 32 #32 * i + level * 32
			
	else:
		for i in range(row_amount/2, row_amount):
			rows[i].position.y = (i * level) * 32 #32 * i + level * 32
			

func default_rows():
	print("default")
	
	for i in range(row_amount):
#		rows[i].position.y = position.y
		rows[i].position.y = 32 * (i-1) - position.y
		print("row: ", i, ", position", rows[i].position.y)
