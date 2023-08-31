extends CharacterBody2D
class_name Player

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var FRICTION = 5.0

var xVel = 0
var yVel = 0
#var xScl = 0
#var yScl = 0
var hp = 3
var bullet = load("res://Scenes/bullet.tscn")

func _physics_process(delta):
	xVel = Input.get_axis("Left", "Right")
	yVel = Input.get_axis("Up", "Down")
	velocity.x = move_toward(velocity.x, xVel * SPEED * delta * 10000, FRICTION)
	velocity.y = move_toward(velocity.y, yVel * SPEED * delta * 10000, FRICTION)
	#xScl = move_toward(scale.x, (abs(xVel) - 0.5) / 8, FRICTION)
	if Input.is_action_just_pressed("Fire") and $Timer.is_stopped():
		var bul = bullet.instantiate()
		bul.position = Vector2(position.x, position.y - 180)
		bul.scale = Vector2(0.2, 0.2)
		Global.emit_signal("add_bullet", bul)
		$Timer.start()
		

	move_and_slide()
	
	if position.x < 0:
		position.x = 0
	elif position.x > 1080:
		position.x = 1080
	if position.y < 0:
		position.y = 0
	elif position.y > 1920:
		position.y = 1920

func on_die():
	$Sprite2D.visible = false
	$CollisionPolygon2D.queue_free()
	$GPUParticles2D.emitting = true
	$AudioStreamPlayer.play()
	
	await get_tree().create_timer(1).timeout
	
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
