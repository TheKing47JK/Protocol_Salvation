extends TextureButton

func _ready():
	self.pressed.connect(_on_pressed)

func _on_pressed():
	stageManager.current_stage_index = 0
	TransitionManager.transition_to("res://stage/stage_main.tscn")
