extends Node2D


var rng = RandomNumberGenerator.new()
var enemy = preload("res://Scenes/enemy.tscn")
var spawn_offset = 5
var score = 0
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("add_bullet", add_bullet)
	Global.connect("hurt_player", on_hurt)
	Sounds.play("click")
	$Timer.start(2)

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Back"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	time += delta
	$GameHUD/Label2.text = "%01d:%02d" % [int(time / 60), int(time) % 60]


func add_bullet(bullet):
	add_child(bullet)

func add_score():
	score += 1
	$GameHUD/Label.text = str(score)

func on_hurt():
	$Player.hp -= 1
	match $Player.hp:
		2:
			$GameHUD/Srdce3.visible = false
		1:
			$GameHUD/Srdce2.visible = false
		0:
			$GameHUD/Srdce1.visible = false
			Saver.add_record(score, int(time))
			$Player.on_die()

func _on_timer_timeout():
	var en = enemy.instantiate()
	en.position = Vector2(rng.randi_range(80, 1000), 100)
	en.scale = Vector2(2, 2)
	add_child(en)
	$Timer.start(rng.randf_range(1, spawn_offset))
	spawn_offset -= 0.2

func get_player_pos():
	return $Player.position
