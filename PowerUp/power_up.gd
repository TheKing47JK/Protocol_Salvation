class_name Powerup
extends Area2D

@export var powerup_movespeed: float =100

func _physics_process(delta: float) -> void:
	global_position.y += powerup_movespeed * delta

func applyPowerup(body: ShipPlayer):
	#this will be included in the inheriting class
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is ShipPlayer:
		applyPowerup(body)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
