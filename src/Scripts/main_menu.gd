extends Control

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.

func _ready():
	Sounds.play("click")

func _on_hrat_button_mouse_entered():
	$HratSprite2D.play("Off")


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_hrat_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")


func _on_zebricek_button_mouse_entered():
	$ZebricekSprite2D.play("On")


func _on_zebricek_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/zebricek_menu.tscn")


func _on_exit_button_mouse_entered():
	$ExitBackground.scale = Vector2(1.1, 1.1)
	$ExitBackground.rotation_degrees = -5


func _on_exit_button_mouse_exited():
	$ExitBackground.scale = Vector2(1.0, 1.0)
	$ExitBackground.rotation_degrees = 0


func _on_exit_button_pressed():
	get_tree().quit()


func _on_zebricek_button_mouse_exited():
	$ZebricekSprite2D.play("Off")


func _on_hrat_button_mouse_exited():
	$HratSprite2D.play("On")


func _on_tabor_timer_timeout():
	$TaborBude.visible = not $TaborBude.visible
	$TaborTimer.start(rng.randf())
