extends Control

@onready var corner_glow: ColorRect = $CornerGlow
@onready var powerup_label: Label = $PowerupLabel

var active := false
var duration := 0.0
var time_left := 0.0
var base_color: Color = Color.WHITE

const LABEL_DURATION := 1.5
var label_time_left := 0.0

func activate_powerup(name: String, duration_sec: float, color: Color) -> void:
	# Initialize state
	active = true
	duration = max(duration_sec, 0.001)
	time_left = duration
	base_color = color

	# Show label
	powerup_label.text = name
	powerup_label.visible = true
	powerup_label.modulate.a = 1.0  # reset alpha
	label_time_left = LABEL_DURATION

	# Show glow and set color/intensity to full
	corner_glow.visible = true
	var mat := corner_glow.material as ShaderMaterial
	mat.set_shader_parameter("glow_color", Color(color.r, color.g, color.b, 1.0))
	mat.set_shader_parameter("intensity", 1.0)

func _process(delta: float) -> void:
	if not active:
		return

	time_left -= delta
	label_time_left -= delta
	var t: float = clamp(time_left / duration, 0.0, 1.0)

	# Fade glow intensity
	var mat := corner_glow.material as ShaderMaterial
	mat.set_shader_parameter("intensity", t)

	# Smooth fade out of label
	if label_time_left > 0.0:
		var label_t :float = clamp(label_time_left / LABEL_DURATION, 0.0, 1.0)
		powerup_label.modulate.a = label_t
	else:
		powerup_label.visible = false

	# End powerup
	if time_left <= 0.0:
		active = false
		corner_glow.visible = false
