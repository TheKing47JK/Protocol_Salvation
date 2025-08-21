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
	# Preload the explosion scene resource
	var explosion_scene = preload("res://scenes/explosion.tscn")
	# Create an instance of the explosion
	var explosion = explosion_scene.instantiate()
	# Place the explosion at this enemy's current position
	explosion.position = position
	get_parent().add_child(explosion)
	call_deferred("_spawn_mini_bots_and_free")

func _spawn_mini_bots_and_free():
	var spacing = 96  # adjust spacing between bots
	var start_x = global_position.x - spacing  # center the line on the current position
	
	for i in range(mini_bot_count):
		var bot = mini_bot_scene.instantiate()
		var offset_x = start_x + i * spacing
		var spawn_position = Vector2(offset_x, global_position.y)
		bot.global_position = spawn_position
		get_parent().add_child(bot)
	
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is ShipPlayer:
		body.take_hit(1)
		die()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
