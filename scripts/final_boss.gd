extends "res://scripts/enemy.gd"
class_name FinalBoss

@export var current_max_health: int = 100
@export var bullet_scene: PackedScene
@onready var muzzles_enemy : Array[Node] = [ $MuzzleEnemy, $MuzzleEnemy2, $MuzzleEnemy3, $MuzzleEnemy4 ]

func _ready():
	for child in get_children():
		if child is Marker2D:
			muzzles_enemy.append(child)
	# Initialize health
	health = current_max_health
	# Create and show health bar
	_ensure_hp_bar()
	_update_hp_bar()

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
	
		
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _ensure_hp_bar() -> void:
	# Create the health bar if it doesn't exist yet
	if hp_bar and hp_bar.is_inside_tree(): return
	hp_bar = HealthBar2D.new()
	hp_bar.name = "HPBar"
	add_child(hp_bar)
	# Configure its position above the bot and size
	hp_bar.offset = Vector2(7, -50) #Lucky 7 old shit
	hp_bar.size = Vector2(258, 22)

func _update_hp_bar() -> void:
	# Update the ratio (current / max health) and visibility
	if hp_bar:
		var r := float(health) / float(current_max_health)
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
	
func _on_body_entered(body: Node2D) -> void:
	if body is ShipPlayer:
		body.take_damage(1)
		
