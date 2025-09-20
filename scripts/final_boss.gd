extends "res://scripts/enemy.gd"
class_name FinalBoss

@export var current_max_health: int = 100
@export var bullet_scene: PackedScene
@onready var muzzles_enemy : Array[Node] = [ $MuzzleEnemy, $MuzzleEnemy2, $MuzzleEnemy3, $MuzzleEnemy4 ]

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var enemy_container: Node2D = $EnemyContainer

@export var enemy_scenes := {
	"normal": preload("res://scenes/enemy_1.tscn"),
	"kamikaze": preload("res://scenes/enemy_2.tscn"),
	"splitting": preload("res://scenes/enemy_3.tscn"),
	"bouncing" : preload("res://scenes/bouncing.tscn")
}

var game_start_time: float = 0.0

func _ready():
	for child in get_children():
		if child is Marker2D:
			muzzles_enemy.append(child)
	# Initialize health
	health = current_max_health
	# Create and show health bar
	_ensure_hp_bar()
	_update_hp_bar()

	# Start spawning minions
	enemy_spawn_timer.wait_time = 3.0  # spawn every 3s
	enemy_spawn_timer.timeout.connect(_on_enemy_spawn_timer_timeout)
	enemy_spawn_timer.start()

func _physics_process(delta: float) -> void:
	position.x = 377
	position.y = 214
	 
	shoot_timer -= delta
	if shoot_timer <= 0:
		shoot_enemy()
		shoot_timer = shoot_interval

func shoot_enemy():
	for muzzle_enemy in muzzles_enemy:
		laser_enemy_shoot.emit(laser_enemy_scene, muzzle_enemy.global_position)
	if shoot_sound_enemy:
		if shoot_sound_enemy.playing:
			shoot_sound_enemy.stop()
		shoot_sound_enemy.play()

func die():
	# Stop spawning when dead
	if enemy_spawn_timer:
		enemy_spawn_timer.stop()

	# Spawn an explosion effect
	var explosion_scene = preload("res://scenes/explosion.tscn")
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	get_parent().add_child(explosion)
	_on_enemy_destroyed(global_position)

	var cam = _find_shake_camera()
	if cam:
		cam.shake(20.0)
		cam.zoom_in(0.7, 2.0)
		await get_tree().create_timer(0.8).timeout
		cam.zoom_in(1.0, 2.0)

	queue_free()
	queue_free()
	
func take_damage(amount: int) -> void:
	health = max(health - amount, 0)

	if hit_by_player:
		hit_by_player.play()

	_update_hp_bar()

	# a short shake, the intensity increases as the health decreases
	var hp_ratio = float(health) / float(current_max_health)
	var shake_amount = lerp(1.0, 12.0, 1.0 - hp_ratio)
	var cam = _find_shake_camera()
	if cam:
		cam.shake(shake_amount)

	if health <= 0:
		die()
	
	
func _find_shake_camera() -> Node:
	var nodes := get_tree().get_nodes_in_group("main_camera")
	for n in nodes:
		if n and n.has_method("shake"):
			return n
	return null

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
func _ensure_hp_bar() -> void:
	if hp_bar and hp_bar.is_inside_tree(): return
	hp_bar = HealthBar2D.new()
	hp_bar.name = "HPBar"
	add_child(hp_bar)
	hp_bar.offset = Vector2(7, -50)
	hp_bar.size = Vector2(258, 22)

func _update_hp_bar() -> void:
	if hp_bar:
		var r := float(health) / float(current_max_health)
		hp_bar.set_ratio(r)
		hp_bar.visible = health > 0

func _on_enemy_destroyed(position: Vector2):
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
	
func _on_body_entered(body: Node2D) -> void:
	if body is ShipPlayer:
		body.take_damage(1)

# -------------------------------
# NEW: Boss spawns random minions
# -------------------------------
func _on_enemy_spawn_timer_timeout() -> void:
	if not enemy_container:
		return
	# pick random enemy type
	var enemy_type: String = str(enemy_scenes.keys().pick_random())
	var enemy_scene: PackedScene = enemy_scenes[enemy_type]
	if not enemy_scene:
		return

	var enemy = enemy_scene.instantiate()
	# spawn near the boss
	enemy.global_position = Vector2(randf_range(100, 700), -50)
	enemy_container.add_child(enemy)
	print("Boss spawned minion: ", enemy_type)
