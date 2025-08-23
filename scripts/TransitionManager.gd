extends CanvasLayer

# Create a ColorRect that will cover the entire screen (used for fade in/out)
@onready var rect: ColorRect = ColorRect.new()

func _ready():
	# Set initial properties for the ColorRect
	rect.color = Color.BLACK
	rect.size = get_viewport().size
	rect.modulate.a = 0.0
	add_child(rect)

	# Connect signal to resize the ColorRect when the window/viewport size changes
	get_viewport().size_changed.connect(_on_viewport_resized)

func _on_viewport_resized():
	# Update the rect size to always cover the full viewport
	rect.size = get_viewport().size

func fade_in(duration: float = 1.0) -> void:
	# Fade from opaque to transparent, scene becomes visible
	rect.size = get_viewport().size
	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, duration)

func fade_out(duration: float = 1.0) -> void:
	# Fade from transparent to opaque, screen turns black
	rect.size = get_viewport().size
	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, duration)
	# Wait until fade completes
	await tween.finished

func transition_to(scene_path: String, duration: float = 1.0) -> void:
	# Perform a fade-out, change scene, then fade-in
	await fade_out(duration)
	# Load the new scene
	get_tree().change_scene_to_file(scene_path)
	fade_in(duration)
