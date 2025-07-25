extends ParallaxBackground

@onready var space_layer: ParallaxLayer = $SpaceLayer
@onready var nebula_001_layer: ParallaxLayer = $Nebula001Layer
@onready var nebula_002_layer: ParallaxLayer = $Nebula002Layer
@onready var small_stars_layer: ParallaxLayer = $SmallStarsLayer
@onready var stars_layer: ParallaxLayer = $StarsLayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	stars_layer.motion_offset.y += 60 * delta
	space_layer.motion_offset.y += 30 * delta
	nebula_001_layer.motion_offset.y += 30 * delta
	nebula_002_layer.motion_offset.y += 30 * delta
	small_stars_layer.motion_offset.y += 40 * delta
