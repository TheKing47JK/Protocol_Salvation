extends TextureButton

func _ready():
	self.pressed.connect(_on_pressed)

func _on_pressed():
	TransitionManager.transition_to("res://stage/stage1.tscn")
