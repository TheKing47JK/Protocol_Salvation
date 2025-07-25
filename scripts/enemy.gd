extends Area2D
class_name Enemy

@export var speed: float = 200
@export var shoot_interval: float = 3

@onready var muzzle_enemy := $MuzzleEnemy if has_node("MuzzleEnemy") else null

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
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is ShipPlayer:
		body.die()
		die()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
