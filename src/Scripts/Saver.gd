extends Node

var data: ScoreDat
# Called when the node enters the scene tree for the first time.
func _ready():
	loadd()

func add_record(score: int, time: int):
	data.score.append(score)
	data.time.append(time)

func loadd():
	if ResourceLoader.exists("res://score_data.tres"):
		data = ResourceLoader.load("res://score_data.tres")
	else:
		data = ScoreDat.new()

func saved():
	ResourceSaver.save(data, "res://score_data.tres")

func erase():
	data = ScoreDat.new()
	saved()

#func update_records():
#	$Table.text = "[b]Hra  Čas  Skóre[/b]\n"
#	for i in len(data.time):
#		$Table.text += "{0:5}{1:5}{2:5}\n".format([i + 1, data.time[i], data.score[i]])
		
func _exit_tree():
	saved()
