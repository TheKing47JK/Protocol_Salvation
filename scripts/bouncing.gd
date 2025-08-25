extends "res://scripts/enemy.gd"

@export var horizontalSpeed := 200
@export var verticalSpeed := 50
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var min_x: float = 100.0   # left boundary
@export var max_x: float = 700.0   # right boundary

var horizontalDirection : int = 1

func _ready():
	if has_node("MuzzleEnemy"):
		muzzle_enemy = $MuzzleEnemy
	
	# Initialize health
	health = max_health
	# Create and show health bar
	_ensure_hp_bar()
	_update_hp_bar()

func _physics_process(delta):
	#Automatically move horizontally
	position.x += horizontalSpeed * delta * horizontalDirection
	position.y += verticalSpeed * delta
	
	# Bounce at boundaries
	if position.x <= min_x:
		position.x = min_x
		horizontalDirection = 1
	elif position.x >= max_x:
		position.x = max_x
		horizontalDirection = -1
	
	#Animation moving left and right
	if horizontalDirection < 0:
		animated_sprite_2d.play("move_left")
	elif horizontalDirection > 0:
		animated_sprite_2d.play("move_right")
	
	shoot_timer -= delta
	if shoot_timer <= 0:
		shoot_enemy()
		shoot_timer = shoot_interval

func shoot_enemy():
	if muzzle_enemy:
		laser_enemy_shoot.emit(laser_enemy_scene, muzzle_enemy.global_position)
	# If a shooting sound exists, play it (restart if it is already playing)
	if shoot_sound_enemy:
		if shoot_sound_enemy.playing:
			shoot_sound_enemy.stop()
		shoot_sound_enemy.play()

func die():

	# Spawn an explosion effect at this position
	var explosion_scene = preload("res://scenes/explosion.tscn")
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	get_parent().add_child(explosion)
	_on_enemy_destroyed(global_position)
	queue_free()
	
func take_damage(amount: int) -> void:
	# Reduce health and update health bar
	health = max(health - amount, 0)
	# If a "hit" sound effect exists, play it to give feedback
	if hit_by_player:
		hit_by_player.play()
	# Update the health bar to reflect the new health value
	_update_hp_bar()
	if health <= 0:
		die()

func _on_body_entered(body: Node2D) -> void:
	if body is ShipPlayer:
		body.take_damage(1)
		die()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _ensure_hp_bar() -> void:
	# Create the health bar if it doesn't exist yet
	if hp_bar and hp_bar.is_inside_tree(): return
	hp_bar = HealthBar2D.new()
	hp_bar.name = "HPBar"
	add_child(hp_bar)
	# Configure its position above the bot and size
	hp_bar.offset = Vector2(0, -50)
	hp_bar.size = Vector2(58, 12)

func _update_hp_bar() -> void:
	# Update the ratio (current / max health) and visibility
	if hp_bar:
		var r := float(health) / float(max_health)
		hp_bar.set_ratio(r)
		hp_bar.visible = health > 0

	
func _on_enemy_destroyed(position: Vector2):
	# Check if a power-up should spawn
	if randf() * 100 > drop_chance:
		return  

	var powerup_name = choose_weighted(weights)
	var scene = POWERUPS[powerup_name]
	var powerup = scene.instantiate()
	get_parent().add_child(powerup)
	powerup.global_position = position


func choose_weighted(weights: Dictionary) -> String:
	var total_weight = 0
	for w in weights.values():
		total_weight += w

	var rand_value = randi() % total_weight
	var cumulative = 0

	for name in weights.keys():
		cumulative += weights[name]
		if rand_value < cumulative:
			return name
	return weights.keys()[0]
