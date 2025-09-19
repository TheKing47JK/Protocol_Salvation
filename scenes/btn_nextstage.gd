extends TextureButton

func _ready():
	self.pressed.connect(_on_pressed)

func _on_pressed():
	var stage_manager = get_tree().root.get_node("stageManager")
	if stage_manager:
		stage_manager.next_stage()
