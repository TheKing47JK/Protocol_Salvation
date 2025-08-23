extends Control

@onready var corner_glow: ColorRect = $CornerGlow
@onready var powerup_label: Label = $PowerupLabel

var active := false
var duration := 0.0
var time_left := 0.0
var base_color: Color = Color.WHITE

var label_time_left := 0.0   # separate timer for label display

func activate_powerup(name: String, duration_sec: float, color: Color) -> void:
	# Initialize state
	active = true
	duration = max(duration_sec, 0.001)
	time_left = duration
	base_color = color

	# Show label
	powerup_label.text = name
	powerup_label.visible = true
	label_time_left = 1.5  # show label for 1.5 second

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

	# Fade intensity as time passes
	var mat := corner_glow.material as ShaderMaterial
	mat.set_shader_parameter("intensity", t)

	# Hide label after 1.5 sec
	if label_time_left <= 0.0:
		powerup_label.visible = false

	# End powerup
	if time_left <= 0.0:
		active = false
		corner_glow.visible = false
