extends "res://scripts/enemy.gd"

class_name EnemySplitter

@export var mini_bot_scene: PackedScene
@export var mini_bot_count: int = 3

func _ready():
	super._ready()
	if has_node("MuzzleEnemy"):
		muzzle_enemy = $MuzzleEnemy

func _physics_process(delta):
	super._physics_process(delta) 
	global_position.y += speed * delta

func die():
	call_deferred("_spawn_mini_bots_and_free")

func _spawn_mini_bots_and_free():
	for i in range(mini_bot_count):
		var bot = mini_bot_scene.instantiate()
		bot.global_position = global_position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
		get_parent().add_child(bot)
	queue_free()

func _on_body_entered(body):
	if body is ShipPlayer:
		body.die()
		die()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
