extends Control


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		
# Called when the node enters the scene tree for the first time.
func _ready():
	update_records()
	$AudioStreamPlayer.play()

func update_records():	
	for i in len(Saver.data.time):
		$Table.text += "%-5d%01d:%02d %5d\n" % [i + 1, int(Saver.data.time[i] / 60), Saver.data.time[i] % 60, Saver.data.score[i]]

func _on_hrat_button_mouse_entered():
	$BackBackground.scale = Vector2(0.6, 0.6)
	$BackBackground.rotation_degrees = 0


func _on_hrat_button_mouse_exited():
	$BackBackground.scale = Vector2(0.5, 0.5)
	$BackBackground.rotation_degrees = -8


func _on_hrat_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_erase_button_pressed():
	Saver.erase()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_erase_button_mouse_entered():
	$EraseButton.modulate = Color.GRAY


func _on_erase_button_mouse_exited():
	$EraseButton.modulate = Color.WHITE
