extends ProgressBar

@onready var plane := $Sprite2D

var total_time := 150.0 # 2.5 mina
var current_time := 0.0

func _ready():
	min_value = 0
	max_value = total_time
	value = 0

func _process(delta):
	if current_time < total_time:
		current_time += delta * 2
		value = current_time

		# progress ratio (0 → 1)
		var ratio = value / max_value

		# bar height in pixels
		var bar_height = size.y

		# move plane upward (0 at top, bar_height at bottom)
		plane.position.y = bar_height - (ratio * bar_height)
