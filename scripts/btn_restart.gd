extends TextureButton

func _ready():
	self.pressed.connect(_on_pressed)

func _on_pressed():
	stageManager.current_stage_index = 0   # Reset to the first level
	stageManager.load_stage(0)             # Start from stage1
