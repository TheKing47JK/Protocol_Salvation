# to enable parallax effect on layers
extends ParallaxBackground

# Declare the layers as variables and initialize them using 'onready' 
# so they can be used once the scene is ready
@onready var space_layer: ParallaxLayer = $SpaceLayer
@onready var nebula_001_layer: ParallaxLayer = $Nebula001Layer
@onready var nebula_002_layer: ParallaxLayer = $Nebula002Layer
@onready var small_stars_layer: ParallaxLayer = $SmallStarsLayer
@onready var stars_layer: ParallaxLayer = $StarsLayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
# This is the main update loop that controls the motion of the parallax layers
func _process(delta: float) -> void:
	# Adjust the vertical motion offset of the layer. The more positive the value, the faster it moves.
	# The motion_offset property controls the movement of the layers. 
	# The value of y is changed based on delta to make the layers move. 
	# The delta value ensures smooth and frame-rate independent movement, 
	# where the number is multiplied by the time passed between frames (delta).
	stars_layer.motion_offset.y += 60 * delta
	space_layer.motion_offset.y += 30 * delta
	nebula_001_layer.motion_offset.y += 30 * delta
	nebula_002_layer.motion_offset.y += 30 * delta
	small_stars_layer.motion_offset.y += 40 * delta
