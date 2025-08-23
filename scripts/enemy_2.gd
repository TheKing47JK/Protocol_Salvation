extends "res://scripts/enemy.gd"
class_name KamikazeBot


@export var speed: float = 200
@export var max_health: int = 2
# Current health value (set in _ready)
var health: int
# Preload the custom HealthBar2D script
const HealthBar2D = preload("res://scripts/HealthBar2D.gd")
# Reference to the health bar instance
var hp_bar: Node2D = null   

var laser_enemy_scene = preload("res://scenes/laser_enemy.tscn")
signal laser_enemy_shoot(laser_enemy_scene, location)
var shoot_timer := 0.0
@onready var hit_by_player: AudioStreamPlayer2D = $HitByPlayer

func _ready():
	# Initialize health
	health = max_health
	# Create and show health bar
	_ensure_hp_bar()
	_update_hp_bar()


func _physics_process(delta: float) -> void:
	global_position.y += speed * delta

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
