extends CharacterBody2D

class_name Bullet

@export var SPEED = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Sounds.play("pew")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += SPEED * delta * Vector2.UP
	if position.y < 0 or position.y > 1920 or position.x < 0 or position.x > 1080:
		queue_free()
	

func _on_area_2d_body_entered(body):
	if body is Enemy:
		body.on_die()
		$/root/MainGame.add_score()
	elif body is EnemyBullet:
		body.queue_free()
	queue_free()
