extends CharacterBody2D
class_name Enemy

var enemies = [
	"res://Assets/vendi smich.png",
	"res://Assets/ondra1 hotovo.png",
	"res://Assets/hurd-mraceni.png"
]

@export var SPEED: float
@export var MOVEMENT: float
var rng = RandomNumberGenerator.new()
var bullet = load("res://Scenes/enemy_bullet.tscn")
var sin_rad = 0.0

func _ready():
	$Sprite2D.scale = Vector2(1, 1)
	var enemy_tex = enemies[rng.randi_range(0, 2)]
	$Sprite2D.texture = load(enemy_tex)
	if enemy_tex == "res://Assets/hurd-mraceni.png":
		$Sprite2D.scale = Vector2(0.1, 0.1)
	$Timer.start(rng.randi_range(1, 5))
	
func on_die():
	Sounds.play("boom")
	$Timer.stop()
	$Sprite2D.visible = false
	$CollisionShape2D.queue_free()
	$GPUParticles2D.emitting = true
	
	await get_tree().create_timer(1).timeout
	
	queue_free()

func _physics_process(delta):
	velocity.y = SPEED
	sin_rad += 0.05
#	if sin_rad > 2:
#		sin_rad = 0
	velocity.x = sin(sin_rad) * MOVEMENT
	
	move_and_slide()

func _on_timer_timeout():
	var bul = bullet.instantiate()
	bul.position = Vector2(position.x, position.y)
	bul.pVec = $/root/MainGame.get_player_pos()
	Global.emit_signal("add_bullet", bul)
	$Timer.start(rng.randi_range(1, 5))
