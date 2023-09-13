extends AnimationPlayer


func _on_area_2d_body_entered(body):
	if body is Player:
		Global.emit_signal("hurt_player")
