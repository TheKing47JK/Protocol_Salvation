extends TextureButton

func _ready():
	connect("pressed",self,"_on_pressed")

func _on_pressed():
	get.tree().change_screen("res://")
