extends CharacterBody2D

class_name EnemyBullet

var bullets = [
	"res://Assets/flashka.png",
	"res://Assets/glasses.png",
	"res://Assets/green_mobile.png",
	"res://Assets/Kamera 1.png",
	"res://Assets/Kamera 11.png",
	"res://Assets/keyboard.png",
	"res://Assets/Myska.png",
	"res://Assets/red_mobile.png",
	"res://Assets/sd_card.png",
	"res://Assets/white_mobile.png"
]

var rng = RandomNumberGenerator.new()
var pVec = Vector2()
@export var SPEED: float

func _ready():
	var tex = bullets[rng.randi_range(0, 9)]
	$Sprite2D.texture = load(tex)
	scale = Vector2(0.5, 0.5)
	if tex in ["res://Assets/red_mobile.png", "res://Assets/green_mobile.png"]:
		scale = Vector2(0.125, 0.125)
		$Area2D.scale = Vector2(4, 4)
	Sounds.play("pew")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += delta * Vector2.DOWN * SPEED
	if position.y < 0 or position.y > 1920 or position.x < 0 or position.x > 1080:
		queue_free()


func _on_area_2d_body_entered(body):
	if body is Player:
		Global.emit_signal("hurt_player")
	if body is Bullet:
		body.free()
	queue_free()
