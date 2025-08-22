extends "res://scripts/enemy.gd"

@export var horizontalSpeed := 100.0
@export var verticalSpeed := 30.0 
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var horizontalDirection : int = 1

func _ready():
	if has_node("MuzzleEnemy"):
		muzzle_enemy = $MuzzleEnemy

func _physics_process(delta):
	#Automatically move horizontally
	position.x += horizontalSpeed * delta * horizontalDirection
	position.y += verticalSpeed * delta
	
	#Bounce off the wall
	var viewReact := get_viewport_rect()
	if position.x < viewReact.position.x or position.x > viewReact.end.x:
		horizontalDirection += -1
	
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

func die():
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
	

	
	
