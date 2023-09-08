extends CharacterBody2D
class_name Player

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var FRICTION = 5.0

var input_vel: Vector2
var joist_vel: Vector2
var hp = 3
var bullet = load("res://Scenes/bullet.tscn")

func _ready():
	Global.connect("fire_bullet", fire_bullet)
	Global.connect("move_player", player_move)

func _physics_process(delta):
	input_vel.x = Input.get_axis("Left", "Right")
	input_vel.y = Input.get_axis("Up", "Down")
	
	velocity.x = move_toward(velocity.x, input_vel.x * SPEED * delta * 10000, FRICTION)
	velocity.y = move_toward(velocity.y, input_vel.y * SPEED * delta * 10000, FRICTION)
	
	if Input.is_action_just_pressed("Fire") and $Timer.is_stopped():
		fire_bullet()

	move_and_slide()
	
	if position.x < 0:
		position.x = 0
	elif position.x > 1080:
		position.x = 1080
	if position.y < 1000:
		position.y = 1000
	elif position.y > 1920:
		position.y = 1920

func fire_bullet():
	var bul = bullet.instantiate()
	bul.position = Vector2(position.x, position.y - 180)
	bul.scale = Vector2(0.2, 0.2)
	Global.emit_signal("add_bullet", bul)
	$Timer.start()

func player_move(vec: Vector2):
	joist_vel = vec

func on_die():
	$Sprite2D.visible = false
	$CollisionPolygon2D.queue_free()
	$GPUParticles2D.emitting = true
	$AudioStreamPlayer.play()
	
	await get_tree().create_timer(1).timeout
	
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
