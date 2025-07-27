#script for enemy
extends Area2D
class_name enemy

@export var verticalSpeed = 10.0
@export var health: int = 5

func _ready() -> void:
	set_process(true)
	pass # Replace with function body.

#enemy move from top to bottom
func _physics_process(delta):
	position.y += verticalSpeed * delta

#enemy get damaged
func damage(amount: int):
	print("Enemy damaged! Take the chance to eliminate them all! ")
	health -= amount
	if health <= 0:
		queue_free()
		print("Enemy eliminated!")

#if enemy moved out of the screen, then it exited 
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	pass # Replace with function body.
