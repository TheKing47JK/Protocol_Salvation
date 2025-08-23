extends Node2D

# The overall size of the health bar
@export var size := Vector2(50, 6)
# Offset from the parent node's origin
@export var offset := Vector2(0, -32)
# Background color of the health bar (empty part)
@export var back_color := Color(0, 0, 0, 0.6)
# Colors for different health levels
@export var fill_full := Color(0.2, 0.9, 0.2)
@export var fill_mid  := Color(0.95, 0.8, 0.2)
@export var fill_low  := Color(1.0, 0.2, 0.2)
# Whether to draw a border around the health bar
@export var show_border := true

# Current health ratio (0.0 = empty, 1.0 = full)
var ratio := 1.0

# Update the ratio (health percent) and redraw the bar
func set_ratio(r: float) -> void:
	ratio = clamp(r, 0.0, 1.0)
	queue_redraw()

func _process(_dt: float) -> void:
	# Always position the bar relative to its parent
	position = offset

func _draw() -> void:
	var half_w := size.x * 0.5
	# Background rectangle (dark bar behind the fill)
	var rect := Rect2(Vector2(-half_w, -size.y), size)
	draw_rect(rect, back_color, true)
	# Choose fill color based on remaining ratio
	var col := fill_full if ratio > 0.5 else (fill_mid if ratio > 0.2 else fill_low)
	# Draw the filled portion of the bar
	var fill_w := size.x * ratio
	var fill_rect := Rect2(Vector2(-half_w, -size.y), Vector2(fill_w, size.y))
	draw_rect(fill_rect, col, true)
	# Optionally draw border around the whole bar
	if show_border:
		draw_rect(rect, Color(0, 0, 0, 1), false, 1.0)
