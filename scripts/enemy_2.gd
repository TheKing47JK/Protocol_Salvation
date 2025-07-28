extends Area2D
class_name KamikazeBot

@export var speed: float = 200
@export var health: int = 5

var laser_enemy_scene = preload("res://scenes/laser_enemy.tscn")
signal laser_enemy_shoot(laser_enemy_scene, location)
var shoot_timer := 0.0

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta

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
