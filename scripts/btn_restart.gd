extends TextureButton

func _ready():
	self.pressed.connect(_on_pressed)

func _on_pressed():
	var currentstage = stageManager.current_stage_index   # Reset to the first level
	stageManager.load_stage(currentstage)             # Start from stage1
