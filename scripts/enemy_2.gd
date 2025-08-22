extends "res://scripts/enemy.gd"
class_name KamikazeBot


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
