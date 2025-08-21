extends Area2D
class_name MiniBot

@export var speed: float = 200
@export var shoot_interval: float = 3
@export var max_health: int = 3
# Current health value (set in _ready)
var health: int 
@onready var muzzle_enemy := $MuzzleEnemy if has_node("MuzzleEnemy") else null
@onready var shoot_sound_enemy: AudioStreamPlayer2D = $ShootSoundEnemy if has_node("ShootSoundEnemy") else null
@onready var hit_by_player: AudioStreamPlayer2D = $HitByPlayer if has_node("HitByPlayer") else null

var laser_enemy_scene = preload("res://scenes/laser_enemy.tscn")
signal laser_enemy_shoot(laser_enemy_scene, location)
var shoot_timer := 0.0
# Preload the custom HealthBar2D script
const HealthBar2D = preload("res://scripts/HealthBar2D.gd")
# Reference to the health bar instance
var hp_bar: Node2D = null

func _ready():
	if has_node("MuzzleEnemy"):
		muzzle_enemy = $MuzzleEnemy
	# Initialize health
	health = max_health
	# Create and show health bar
	_ensure_hp_bar()
	_update_hp_bar()

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta
	
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
		body.take_hit(1)
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
