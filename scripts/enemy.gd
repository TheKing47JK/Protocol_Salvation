extends Area2D
class_name MiniBot

@export var speed: float = 200
@export var shoot_interval: float = 3
@export var health: int = 5
@onready var muzzle_enemy := $MuzzleEnemy if has_node("MuzzleEnemy") else null

#powerup
const POWERUPS = {
	"extra_life": preload("res://PowerUp/extra_life_power_up.tscn"),
	"shield": preload("res://PowerUp/shield_power_up.tscn"),
	"rapid_fire": preload("res://PowerUp/rapid_fire_power_up.tscn"),
	"speed_boost": preload("res://PowerUp/boost_power_up.tscn"),
}

# Drop chance (%)
@export var drop_chance: float = 30.0  # 30% chance a power-up spawns

# Weighted probabilities (must sum to 100 or just relative weights)
@export var weights := {
	"extra_life": 10,
	"shield": 30,
	"rapid_fire": 40,
	"speed_boost": 20
}

var laser_enemy_scene = preload("res://scenes/laser_enemy.tscn")
signal laser_enemy_shoot(laser_enemy_scene, location)
var shoot_timer := 0.0

func _ready():
	if has_node("MuzzleEnemy"):
		muzzle_enemy = $MuzzleEnemy

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta
	
	shoot_timer -= delta
	if shoot_timer <= 0:
		shoot_enemy()
		shoot_timer = shoot_interval

func shoot_enemy():
	if muzzle_enemy:
		laser_enemy_shoot.emit(laser_enemy_scene, muzzle_enemy.global_position)

func die():
	_on_enemy_destroyed(global_position)
	queue_free()
	
func take_damage(amount: int) -> void:
	health -= amount
	if health  <= 0:
		die()

func _on_body_entered(body: Node2D) -> void:
	if body is ShipPlayer:
		body.take_damage(1)
		die()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
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
