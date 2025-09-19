extends Camera2D

var shake_strength: float = 0.0
var shake_decay: float = 5.0
var rng := RandomNumberGenerator.new()

var target_zoom: Vector2 = Vector2.ONE
var zoom_speed: float = 3.0

func _ready():
	add_to_group("main_camera") 

func _process(delta: float) -> void:
	# shaking logic
	if shake_strength > 0:
		offset = Vector2(
			rng.randf_range(-shake_strength, shake_strength),
			rng.randf_range(-shake_strength, shake_strength)
		)
		shake_strength = max(shake_strength - shake_decay * delta, 0)
	else:
		offset = Vector2.ZERO

	zoom = zoom.lerp(target_zoom, delta * zoom_speed)

func shake(amount: float) -> void:
	shake_strength = amount

	# zoom in
func zoom_in(amount: float = 1.2, duration: float = 0.5) -> void:
	target_zoom = Vector2(amount, amount)
	await get_tree().create_timer(duration).timeout
	target_zoom = Vector2.ONE  # return normal
