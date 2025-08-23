class_name Powerup
extends Area2D

@export var powerup_movespeed: float =100
@export var screen_margin: int = 16 # margin so it won’t clip offscreen

var screen_size: Vector2
var direction: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	var dir_x = -1 if randf() < 0.5 else 1 # Randomly choose left or right
	direction = Vector2(dir_x, 0)

func _physics_process(delta: float) -> void:
	global_position.y += powerup_movespeed * delta
	global_position += direction * powerup_movespeed * delta
	
	if global_position.x < screen_margin:
		global_position.x = screen_margin
		direction.x *= -1
	elif global_position.x > screen_size.x - screen_margin:
		global_position.x = screen_size.x - screen_margin
		direction.x *= -1

func applyPowerup(body: ShipPlayer):
	#this will be included in the inheriting class
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is ShipPlayer:
		applyPowerup(body)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
