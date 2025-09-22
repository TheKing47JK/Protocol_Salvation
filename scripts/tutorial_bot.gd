extends Area2D
class_name tutorial_bot

@export var speed: float = 220
func _physics_process(delta: float) -> void:
	global_position.y += speed * delta
